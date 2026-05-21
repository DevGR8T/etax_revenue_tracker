import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_text_styles.dart';

/// Three quick action buttons — Pay Now, History, Profile.
class QuickActionsBar extends StatelessWidget {
  const QuickActionsBar({
    super.key,
    required this.onPayNow,
    required this.onHistory,
    required this.onProfile,
  });

  final VoidCallback onPayNow;
  final VoidCallback onHistory;
  final VoidCallback onProfile;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _ActionButton(
            label: AppStrings.payNow,
            icon: Icons.add_card_outlined,
            color: AppColors.primary,
            onTap: onPayNow,
          ),
        ),
        AppSpacing.gapHSM,
        Expanded(
          child: _ActionButton(
            label: AppStrings.history,
            icon: Icons.history_rounded,
            color: AppColors.secondary,
            onTap: onHistory,
          ),
        ),
        AppSpacing.gapHSM,
        Expanded(
          child: _ActionButton(
            label: AppStrings.profile,
            icon: Icons.person_outline_rounded,
            color: AppColors.grey600,
            onTap: onProfile,
          ),
        ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: AppSpacing.borderRadiusMD,
          border: Border.all(color: color.withValues(alpha: 0.2)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 22),
            AppSpacing.gapXS,
            Text(
              label,
              style: AppTextStyles.labelSmall.copyWith(color: color),
            ),
          ],
        ),
      ),
    );
  }
}