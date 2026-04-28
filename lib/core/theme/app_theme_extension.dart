import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

/// Custom theme extension for colors that are not
/// covered by the standard Material ColorScheme.
///
/// Usage in widgets:
/// `Theme.of(context).extension<AppThemeExtension>()!.statusPaid`
@immutable
class AppThemeExtension extends ThemeExtension<AppThemeExtension> {
  const AppThemeExtension({
    required this.statusPaid,
    required this.statusPaidBackground,
    required this.statusPending,
    required this.statusPendingBackground,
    required this.statusFailed,
    required this.statusFailedBackground,
    required this.tinCardGradientStart,
    required this.tinCardGradientEnd,
    required this.shimmerBase,
    required this.shimmerHighlight,
  });

  final Color statusPaid;
  final Color statusPaidBackground;
  final Color statusPending;
  final Color statusPendingBackground;
  final Color statusFailed;
  final Color statusFailedBackground;
  final Color tinCardGradientStart;
  final Color tinCardGradientEnd;
  final Color shimmerBase;
  final Color shimmerHighlight;

  /// Light theme extension values
  static const light = AppThemeExtension(
    statusPaid: AppColors.paid,
    statusPaidBackground: AppColors.paidBackground,
    statusPending: AppColors.pending,
    statusPendingBackground: AppColors.pendingBackground,
    statusFailed: AppColors.failed,
    statusFailedBackground: AppColors.failedBackground,
    tinCardGradientStart: AppColors.tinCardGradientStart,
    tinCardGradientEnd: AppColors.tinCardGradientEnd,
    shimmerBase: AppColors.shimmerBase,
    shimmerHighlight: AppColors.shimmerHighlight,
  );

  /// Dark theme extension values
  static const dark = AppThemeExtension(
    statusPaid: AppColors.paid,
    statusPaidBackground: AppColors.paidBackground,
    statusPending: AppColors.pending,
    statusPendingBackground: AppColors.pendingBackground,
    statusFailed: AppColors.failed,
    statusFailedBackground: AppColors.failedBackground,
    tinCardGradientStart: AppColors.tinCardGradientStart,
    tinCardGradientEnd: AppColors.tinCardGradientEnd,
    shimmerBase: AppColors.shimmerBaseDark,
    shimmerHighlight: AppColors.shimmerHighlightDark,
  );

  @override
  AppThemeExtension copyWith({
    Color? statusPaid,
    Color? statusPaidBackground,
    Color? statusPending,
    Color? statusPendingBackground,
    Color? statusFailed,
    Color? statusFailedBackground,
    Color? tinCardGradientStart,
    Color? tinCardGradientEnd,
    Color? shimmerBase,
    Color? shimmerHighlight,
  }) {
    return AppThemeExtension(
      statusPaid: statusPaid ?? this.statusPaid,
      statusPaidBackground:
          statusPaidBackground ?? this.statusPaidBackground,
      statusPending: statusPending ?? this.statusPending,
      statusPendingBackground:
          statusPendingBackground ?? this.statusPendingBackground,
      statusFailed: statusFailed ?? this.statusFailed,
      statusFailedBackground:
          statusFailedBackground ?? this.statusFailedBackground,
      tinCardGradientStart:
          tinCardGradientStart ?? this.tinCardGradientStart,
      tinCardGradientEnd:
          tinCardGradientEnd ?? this.tinCardGradientEnd,
      shimmerBase: shimmerBase ?? this.shimmerBase,
      shimmerHighlight: shimmerHighlight ?? this.shimmerHighlight,
    );
  }

  @override
  AppThemeExtension lerp(
    AppThemeExtension? other,
    double t,
  ) {
    if (other == null) return this;
    return AppThemeExtension(
      statusPaid: Color.lerp(statusPaid, other.statusPaid, t)!,
      statusPaidBackground: Color.lerp(
        statusPaidBackground,
        other.statusPaidBackground,
        t,
      )!,
      statusPending:
          Color.lerp(statusPending, other.statusPending, t)!,
      statusPendingBackground: Color.lerp(
        statusPendingBackground,
        other.statusPendingBackground,
        t,
      )!,
      statusFailed:
          Color.lerp(statusFailed, other.statusFailed, t)!,
      statusFailedBackground: Color.lerp(
        statusFailedBackground,
        other.statusFailedBackground,
        t,
      )!,
      tinCardGradientStart: Color.lerp(
        tinCardGradientStart,
        other.tinCardGradientStart,
        t,
      )!,
      tinCardGradientEnd: Color.lerp(
        tinCardGradientEnd,
        other.tinCardGradientEnd,
        t,
      )!,
      shimmerBase:
          Color.lerp(shimmerBase, other.shimmerBase, t)!,
      shimmerHighlight:
          Color.lerp(shimmerHighlight, other.shimmerHighlight, t)!,
    );
  }
}