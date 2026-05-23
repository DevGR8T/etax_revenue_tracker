import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';

/// Skeleton loading state for the receipt screen.
/// Grey boxes positioned to match exact receipt layout.
class ReceiptSkeleton extends StatelessWidget {
  const ReceiptSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Shimmer.fromColors(
      baseColor: isDark ? AppColors.shimmerBaseDark : AppColors.shimmerBase,
      highlightColor: isDark
          ? AppColors.shimmerHighlightDark
          : AppColors.shimmerHighlight,
      child: Container(
        margin: AppSpacing.screenHorizontal,
        decoration: BoxDecoration(
          color: isDark ? AppColors.cardDark : AppColors.white,
          borderRadius: AppSpacing.borderRadiusLG,
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              // Status icon skeleton
              Container(
                width: 64,
                height: 64,
                decoration: const BoxDecoration(
                  color: AppColors.white,
                  shape: BoxShape.circle,
                ),
              ),
              AppSpacing.gapMD,

              // Status text skeleton
              Container(
                width: 160,
                height: 20,
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              AppSpacing.gapSM,

              // Amount skeleton — large
              Container(
                width: 200,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              AppSpacing.gapLG,

              Container(height: 1, color: AppColors.white),
              AppSpacing.gapMD,

              // Receipt field skeletons
              ..._buildFieldSkeletons(),
              AppSpacing.gapMD,

              // QR code skeleton
              Container(width: 120, height: 120, color: AppColors.white),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildFieldSkeletons() {
    return List.generate(
      6,
      (index) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: 80,
              height: 12,
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            Container(
              width: 120,
              height: 12,
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ],
        ),
      ),
    );
  }
}