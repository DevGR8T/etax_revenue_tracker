import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../domain/entities/payment_entity.dart';

/// Success AlertDialog shown after payment submission.
/// Two options:
/// View Receipt — navigates to Payment Detail screen.
/// Pay Another — clears form and resets state.
///
/// barrierDismissible: false — citizen must make explicit choice.
/// A tax payment confirmation is not accidentally dismissible.
class PaymentSuccessDialog extends StatelessWidget {
  const PaymentSuccessDialog({
    super.key,
    required this.payment,
    required this.onViewReceipt,
    required this.onPayAnother,
  });

  final PaymentEntity payment;
  final VoidCallback onViewReceipt;
  final VoidCallback onPayAnother;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: const RoundedRectangleBorder(
        borderRadius: AppSpacing.borderRadiusLG,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppSpacing.gapSM,
          Container(
            width: 64,
            height: 64,
            decoration: const BoxDecoration(
              color: AppColors.paidBackground,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check_rounded,
              color: AppColors.paid,
              size: 32,
            ),
          ),
          AppSpacing.gapMD,
          Text(
            AppStrings.paymentSubmitted,
            style: AppTextStyles.h4,
            textAlign: TextAlign.center,
          ),
          AppSpacing.gapSM,
          Text(
            payment.receiptNumber,
            style: AppTextStyles.receiptNumber.copyWith(
              color: AppColors.primary,
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
          AppSpacing.gapXS,
          Text(
            payment.formattedAmount,
            style: AppTextStyles.h3.copyWith(color: AppColors.paid),
            textAlign: TextAlign.center,
          ),
          AppSpacing.gapLG,
        ],
      ),
      actions: [
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: onPayAnother,
            child: const Text(AppStrings.payAnother),
          ),
        ),
        AppSpacing.gapXS,
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: onViewReceipt,
            child: const Text(AppStrings.viewReceipt),
          ),
        ),
      ],
      actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
    );
  }
}