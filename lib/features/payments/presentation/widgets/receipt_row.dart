import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';

/// Single label + value row inside the receipt card.
/// Used for Receipt No, Date, Levy Type, Description,
/// Tax ID, Issued By.
class ReceiptRow extends StatelessWidget {
  const ReceiptRow({
    super.key,
    required this.label,
    required this.value,
    this.valueStyle,
    this.isMonospace = false,
  });

  final String label;
  final String value;
  final TextStyle? valueStyle;

  /// True for receipt number and TIN — uses monospace styling.
  final bool isMonospace;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Label — left side fixed width
          SizedBox(
            width: 110,
            child: Text(
              label,
              style: AppTextStyles.receiptLabel.copyWith(
                color: isDark ? AppColors.textSecondaryDark : AppColors.grey500,
              ),
            ),
          ),

          // Value — right side
          Expanded(
            child: Text(
              value,
              style: valueStyle ??
                  (isMonospace
                      ? AppTextStyles.receiptNumber.copyWith(
                          color: isDark
                              ? AppColors.textPrimaryDark
                              : AppColors.textPrimaryLight,
                        )
                      : AppTextStyles.receiptValue.copyWith(
                          color: isDark
                              ? AppColors.textPrimaryDark
                              : AppColors.textPrimaryLight,
                        )),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}