import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/constants/levy_types.dart';

/// Dropdown for levy type selection.
class LevyTypeDropdown extends StatelessWidget {
  const LevyTypeDropdown({
    super.key,
    required this.value,
    required this.onChanged,
    this.enabled = true,
    this.validator,
  });

  final String? value;
  final void Function(String?) onChanged;
  final bool enabled;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Levy Type',
          style: AppTextStyles.labelLarge.copyWith(
            color: isDark
                ? AppColors.textPrimaryDark
                : AppColors.textPrimaryLight,
          ),
        ),
        AppSpacing.gapXS,
        DropdownButtonFormField<String>(
          initialValue: value,
          validator: validator,
          isExpanded: true,
          decoration: const InputDecoration(),
          hint: Text(
            AppStrings.selectLevyType,
            style: TextStyle(
              color: isDark ? AppColors.textHintDark : AppColors.textHintLight,
            ),
          ),
          items: LevyTypes.all
              .map((levy) => DropdownMenuItem(value: levy, child: Text(levy)))
              .toList(),
          onChanged: enabled ? onChanged : null,
        ),
      ],
    );
  }
}