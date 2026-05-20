import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_text_styles.dart';

/// Time-based greeting with citizen name.
/// Good morning / Good afternoon / Good evening.
/// Updates based on current device time.
class GreetingHeader extends StatelessWidget {
  const GreetingHeader({
    super.key,
    required this.citizenName,
  });

  final String citizenName;

  String get _greeting {
    final hour = DateTime.now().hour;
    if (hour < 12) return AppStrings.goodMorning;
    if (hour < 17) return AppStrings.goodAfternoon;
    return AppStrings.goodEvening;
  }

  /// Get first name only for greeting
  String get _firstName {
    final parts = citizenName.trim().split(' ');
    return parts.isNotEmpty ? parts[0] : citizenName;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$_greeting,',
          style: AppTextStyles.bodyMedium.copyWith(
            color: isDark
                ? AppColors.textSecondaryDark
                : AppColors.textSecondaryLight,
          ),
        ),
        Text(
          _firstName,
          style: AppTextStyles.h2,
        ),
      ],
    );
  }
}