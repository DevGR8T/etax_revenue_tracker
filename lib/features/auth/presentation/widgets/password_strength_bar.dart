import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/security/input_validator.dart';

/// Visual password strength indicator.
/// Updates in real time as user types.
/// Weak = red, Fair = amber, Strong = green.
class PasswordStrengthBar extends StatelessWidget {
  const PasswordStrengthBar({
    super.key,
    required this.password,
  });

  final String password;

  @override
  Widget build(BuildContext context) {
    final score = InputValidator.passwordStrength(password);

    if (password.isEmpty) return const SizedBox.shrink();

    final color = switch (score) {
      1 => AppColors.failed,
      2 => AppColors.pending,
      3 => AppColors.paid,
      _ => AppColors.grey200,
    };

    final label = switch (score) {
      1 => 'Weak',
      2 => 'Fair',
      3 => 'Strong',
      _ => '',
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        Row(
          children: List.generate(3, (index) {
            return Expanded(
              child: Container(
                margin: EdgeInsets.only(right: index < 2 ? 4 : 0),
                height: 4,
                decoration: BoxDecoration(
                  color: index < score ? color : AppColors.grey200,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            );
          }),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: AppTextStyles.caption.copyWith(color: color),
        ),
      ],
    );
  }
}