import 'package:flutter_test/flutter_test.dart';
import 'package:etax_revenue_tracker/core/utils/receipt_generator.dart';

void main() {
  final currentYear = DateTime.now().year.toString();

  group('ReceiptGenerator', () {
    group('receiptNumber', () {
      test('generates correct format for id 1', () {
        expect(
          ReceiptGenerator.receiptNumber(1),
          'RCP-$currentYear-00001',
        );
      });

      test('generates correct format for id 42', () {
        expect(
          ReceiptGenerator.receiptNumber(42),
          'RCP-$currentYear-00042',
        );
      });

      test('generates correct format for id 99999', () {
        expect(
          ReceiptGenerator.receiptNumber(99999),
          'RCP-$currentYear-99999',
        );
      });

      test('pads single digit id with zeros', () {
        final result = ReceiptGenerator.receiptNumber(5);
        expect(result, startsWith('RCP-$currentYear-'));
        expect(result, endsWith('00005'));
      });
    });

    group('tin', () {
      test('generates correct TIN format for user 1', () {
        expect(ReceiptGenerator.tin(1), 'NG-00000001');
      });

      test('generates correct TIN format for user 100', () {
        expect(ReceiptGenerator.tin(100), 'NG-00000100');
      });

      test('TIN always starts with NG-', () {
        expect(ReceiptGenerator.tin(42), startsWith('NG-'));
      });

      test('TIN always has 8 digit number part', () {
        final tin = ReceiptGenerator.tin(1);
        final numberPart = tin.substring(3);
        expect(numberPart.length, 8);
      });
    });

    group('tinFromUuid', () {
      test('generates TIN starting with NG- from UUID', () {
        const uuid = 'a1b2c3d4-e5f6-7890-abcd-ef1234567890';
        final tin = ReceiptGenerator.tinFromUuid(uuid);
        expect(tin, startsWith('NG-'));
      });

      test('TIN number part is always 8 digits', () {
        const uuid = 'a1b2c3d4-e5f6-7890-abcd-ef1234567890';
        final tin = ReceiptGenerator.tinFromUuid(uuid);
        final numberPart = tin.substring(3);
        expect(numberPart.length, 8);
      });

      test('same UUID always produces same TIN', () {
        const uuid = 'a1b2c3d4-e5f6-7890-abcd-ef1234567890';
        final tin1 = ReceiptGenerator.tinFromUuid(uuid);
        final tin2 = ReceiptGenerator.tinFromUuid(uuid);
        expect(tin1, tin2);
      });

      test('different UUIDs produce different TINs', () {
        const uuid1 = 'a1b2c3d4-e5f6-7890-abcd-ef1234567890';
        const uuid2 = 'b2c3d4e5-f6a7-8901-bcde-f01234567891';
        final tin1 = ReceiptGenerator.tinFromUuid(uuid1);
        final tin2 = ReceiptGenerator.tinFromUuid(uuid2);
        expect(tin1, isNot(tin2));
      });
    });
  });
}