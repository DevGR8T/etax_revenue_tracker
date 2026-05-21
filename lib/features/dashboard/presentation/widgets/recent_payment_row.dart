import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../domain/entities/recent_payment_entity.dart';
import '../../../payments/presentation/widgets/status_badge.dart';

/// Single row in the Recent Transactions list.
/// Shows levy name, amount, date, and status badge.
/// Tappable — navigates to Payment Detail screen.
class RecentPaymentRow extends StatelessWidget {
  const RecentPaymentRow({
    super.key,
    required this.payment,
    required this.onTap,
  });

  final RecentPaymentEntity payment;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      onTap: onTap,
      borderRadius: AppSpacing.borderRadiusMD,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 12,
          horizontal: 4,
        ),
        child: Row(
          children: [
            // Left icon
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: isDark
                    ? AppColors.grey800
                    : AppColors.grey100,
                borderRadius: AppSpacing.borderRadiusSM,
              ),
              child: Icon(
                Icons.receipt_outlined,
                size: 20,
                color: isDark
                    ? AppColors.textSecondaryDark
                    : AppColors.textSecondaryLight,
              ),
            ),
            AppSpacing.gapHMD,

            // Levy name and date
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    payment.levyName,
                    style: AppTextStyles.labelLarge,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  AppSpacing.gapXS,
                  Text(
                    payment.formattedDate,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: isDark
                          ? AppColors.textSecondaryDark
                          : AppColors.textSecondaryLight,
                    ),
                  ),
                ],
              ),
            ),

            // Amount and status
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  payment.formattedAmount,
                  style: AppTextStyles.labelLarge,
                ),
                AppSpacing.gapXS,
                StatusBadge(status: payment.status),
              ],
            ),
          ],
        ),
      ),
    );
  }
}