import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_text_styles.dart';

/// Logout button with confirmation dialog.
/// Red text — no background — destructive action signal.
/// Confirmation dialog prevents accidental logout.
class LogoutButton extends StatelessWidget {
  const LogoutButton({
    super.key,
    required this.onConfirm,
    this.isLoading = false,
  });

  final VoidCallback onConfirm;
  final bool isLoading;

  void _showConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Logout'),
        content: const Text(AppStrings.logoutConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text(AppStrings.cancel),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              onConfirm();
            },
            child: const Text(
              AppStrings.logout,
              style: TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: TextButton(
        onPressed: isLoading ? null : () => _showConfirmation(context),
        child: isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    AppColors.error,
                  ),
                ),
              )
            : Text(
                AppStrings.logout,
                style: AppTextStyles.button.copyWith(
                  color: AppColors.error,
                ),
              ),
      ),
    );
  }
}