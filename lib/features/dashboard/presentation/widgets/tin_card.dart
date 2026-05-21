import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/utils/extensions/context_extensions.dart';

/// TIN display card with gradient background.
/// Copy icon writes TIN to clipboard and shows snackbar.
class TinCard extends StatelessWidget {
  const TinCard({super.key, required this.tin});

  final String tin;

  Future<void> _copyToClipboard(BuildContext context) async {
    await Clipboard.setData(ClipboardData(text: tin));
    if (context.mounted) {
      context.showSuccessSnackbar(AppStrings.tinCopied);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: AppSpacing.cardPaddingLarge,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.tinCardGradientStart,
            AppColors.tinCardGradientEnd,
          ],
        ),
        borderRadius: AppSpacing.borderRadiusLG,
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Tax Identification Number', style: AppTextStyles.tinLabel),
              const Icon(Icons.account_balance, color: AppColors.white, size: 20),
            ],
          ),
          AppSpacing.gapSM,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(tin, style: AppTextStyles.tinNumber),
              GestureDetector(
                onTap: () => _copyToClipboard(context),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.white.withValues(alpha: 0.15),
                    borderRadius: AppSpacing.borderRadiusSM,
                  ),
                  child: const Icon(
                    Icons.copy_rounded,
                    color: AppColors.white,
                    size: 16,
                  ),
                ),
              ),
            ],
          ),
          AppSpacing.gapXS,
          Text(
            'eTax Revenue Tracker',
            style: AppTextStyles.tinLabel.copyWith(fontSize: 10),
          ),
        ],
      ),
    );
  }
}