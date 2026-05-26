import 'package:etax_revenue_tracker/core/router/route_names.dart';
import 'package:etax_revenue_tracker/shared/widgets/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../domain/entities/payment_entity.dart';
import '../widgets/receipt_card.dart';

class PaymentReceiptScreen extends StatelessWidget {
  const PaymentReceiptScreen({super.key, required this.payment});

  final PaymentEntity payment;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Receipt', style: AppTextStyles.h4),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined),
            tooltip: AppStrings.shareReceipt,
            onPressed: () => Share.share(
              _receiptText(payment),
              subject: 'eTax Receipt — ${payment.receiptNumber}',
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            AppSpacing.gapLG,
            ReceiptCard(payment: payment),
            AppSpacing.gapXL,
            // Done button — takes user back to dashboard
            Padding(
              padding: AppSpacing.screenHorizontal,
              child: PrimaryButton(
                label: 'Done',
                onPressed: () => context.go(RouteNames.dashboard),
              ),
            ),
            AppSpacing.gapXL,
          ],
        ),
      ),
    );
  }

  String _receiptText(PaymentEntity payment) =>
      '''
eTax Revenue Tracker — Payment Receipt

Receipt No: ${payment.receiptNumber}
Amount: ${payment.formattedAmount}
Date: ${payment.formattedDate}
Levy Type: ${payment.levyType}
Description: ${payment.levyName}
Tax ID: ${payment.taxId}
Issued by: ${payment.issuedBy}

Status: ${payment.status.label}
''';
}
