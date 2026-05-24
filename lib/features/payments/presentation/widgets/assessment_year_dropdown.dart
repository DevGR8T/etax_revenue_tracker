import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/constants/levy_types.dart';

/// Dropdown for assessment year selection.
/// Options: 2020 through current year.
class AssessmentYearDropdown extends StatelessWidget {
  const AssessmentYearDropdown({
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
          AppStrings.assessmentYear,
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
            AppStrings.selectYear,
            style: TextStyle(
              color: isDark ? AppColors.textHintDark : AppColors.textHintLight,
            ),
          ),
          items: LevyTypes.assessmentYears
              .map((year) => DropdownMenuItem(value: year, child: Text(year)))
              .toList(),
          onChanged: enabled ? onChanged : null,
        ),
      ],
    );
  }
}