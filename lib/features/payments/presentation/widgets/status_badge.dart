import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../dashboard/domain/entities/recent_payment_entity.dart';

/// Colored status badge — Paid, Pending, Failed.
/// Used on dashboard rows, payment history, and receipt.
/// Single source of truth for status colors across the app.
class StatusBadge extends StatelessWidget {
  const StatusBadge({
    super.key,
    required this.status,
  });

  final PaymentStatus status;

  @override
  Widget build(BuildContext context) {
    final (label, bgColor, textColor) = switch (status) {
      PaymentStatus.paid => (
          'Paid',
          AppColors.paidBackground,
          AppColors.paidText,
        ),
      PaymentStatus.pending => (
          'Pending',
          AppColors.pendingBackground,
          AppColors.pendingText,
        ),
      PaymentStatus.failed => (
          'Failed',
          AppColors.failedBackground,
          AppColors.failedText,
        ),
    };

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 3,
      ),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: AppTextStyles.labelSmall.copyWith(
          color: textColor,
          fontSize: 11,
        ),
      ),
    );
  }
}