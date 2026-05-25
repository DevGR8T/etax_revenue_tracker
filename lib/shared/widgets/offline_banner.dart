import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../core/constants/app_text_styles.dart';

/// Offline banner shown at top of screen when no internet.
/// Non-intrusive — does not block content.
/// Disappears when connection restores.
class OfflineBanner extends StatelessWidget {
  const OfflineBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 10,
      ),
      color: AppColors.grey800,
      child: Row(
        children: [
          const Icon(
            Icons.wifi_off_rounded,
            size: 16,
            color: AppColors.grey400,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              AppStrings.offlineBanner,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.grey400,
              ),
            ),
          ),
        ],
      ),
    );
  }
}