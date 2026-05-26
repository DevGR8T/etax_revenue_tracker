import 'package:flutter_test/flutter_test.dart';
import 'package:etax_revenue_tracker/core/utils/currency_formatter.dart';

void main() {
  group('CurrencyFormatter', () {
    group('format', () {
      test('formats zero as ₦0.00', () {
        expect(CurrencyFormatter.format(0), '₦0.00');
      });

      test('formats integer amount correctly', () {
        expect(CurrencyFormatter.format(5000), '₦5,000.00');
      });

      test('formats decimal amount correctly', () {
        expect(CurrencyFormatter.format(9.99), '₦9.99');
      });

      test('formats large amount with commas', () {
        expect(
          CurrencyFormatter.format(1000000),
          '₦1,000,000.00',
        );
      });

      test('always shows two decimal places', () {
        expect(CurrencyFormatter.format(100), '₦100.00');
      });
    });

    group('parse', () {
      test('parses formatted string back to double', () {
        expect(CurrencyFormatter.parse('₦5,000.00'), 5000.0);
      });

      test('parses plain number string', () {
        expect(CurrencyFormatter.parse('1000'), 1000.0);
      });

      test('returns null for invalid string', () {
        expect(CurrencyFormatter.parse('invalid'), null);
      });

      test('returns null for empty string', () {
        expect(CurrencyFormatter.parse(''), null);
      });
    });
  });
}