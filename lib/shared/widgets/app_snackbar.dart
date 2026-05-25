import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';

/// Centralized snackbar display.
/// Three variants: success, error, info.
/// Consistent styling across every screen.
/// Never define SnackBar inline in widgets — always use this.
abstract final class AppSnackbar {
  static void showSuccess(
    BuildContext context,
    String message,
  ) {
    _show(
      context,
      message: message,
      backgroundColor: AppColors.paid,
      icon: Icons.check_circle_outline_rounded,
    );
  }

  static void showError(
    BuildContext context,
    String message,
  ) {
    _show(
      context,
      message: message,
      backgroundColor: AppColors.error,
      icon: Icons.error_outline_rounded,
    );
  }

  static void showInfo(
    BuildContext context,
    String message,
  ) {
    _show(
      context,
      message: message,
      backgroundColor: AppColors.secondary,
      icon: Icons.info_outline_rounded,
    );
  }

  static void _show(
    BuildContext context, {
    required String message,
    required Color backgroundColor,
    required IconData icon,
  }) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(icon, color: AppColors.white, size: 18),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  message,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.white,
                  ),
                ),
              ),
            ],
          ),
          backgroundColor: backgroundColor,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          margin: const EdgeInsets.all(16),
          duration: const Duration(seconds: 3),
        ),
      );
  }
}