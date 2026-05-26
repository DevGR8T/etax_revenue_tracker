import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:etax_revenue_tracker/features/payments/domain/entities/payment_entity.dart';
import 'package:etax_revenue_tracker/features/payments/domain/entities/payment_status.dart';
import 'package:etax_revenue_tracker/features/payments/presentation/widgets/payment_list_item.dart';

void main() {
  final payment = PaymentEntity(
    id: 1,
    levyName: 'Property Tax',
    levyType: 'property',
    description: 'Annual property tax',
    amount: 4500.00,
    formattedAmount: '₦4,500.00',
    date: DateTime(2024, 1, 5),
    formattedDate: 'Jan 5, 2024',
    status: PaymentStatus.paid,
    receiptNumber: 'RCP-2024-00001',
    taxId: 'NG-00000001',
    issuedBy: 'Enugu State Internal Revenue Service',
  );

  Widget buildWidget() {
    return MaterialApp(
      home: Scaffold(
        body: PaymentListItem(
          payment: payment,
          onTap: () {},
        ),
      ),
    );
  }

  group('PaymentListItem', () {
    testWidgets('renders levy name', (tester) async {
      await tester.pumpWidget(buildWidget());
      expect(find.text('Property Tax'), findsOneWidget);
    });

    testWidgets('renders formatted date', (tester) async {
      await tester.pumpWidget(buildWidget());
      expect(find.text('Jan 5, 2024'), findsOneWidget);
    });

    testWidgets('renders formatted amount', (tester) async {
      await tester.pumpWidget(buildWidget());
      expect(find.text('₦4,500.00'), findsOneWidget);
    });

    testWidgets('renders receipt icon', (tester) async {
      await tester.pumpWidget(buildWidget());
      expect(find.byIcon(Icons.receipt_long_outlined), findsOneWidget);
    });

    testWidgets('renders chevron icon', (tester) async {
      await tester.pumpWidget(buildWidget());
      expect(find.byIcon(Icons.chevron_right_rounded), findsOneWidget);
    });

    testWidgets('calls onTap when tapped', (tester) async {
      var tapped = false;
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: PaymentListItem(
            payment: payment,
            onTap: () => tapped = true,
          ),
        ),
      ));
      await tester.tap(find.byType(InkWell));
      expect(tapped, isTrue);
    });
  });
}