import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/constants/nigerian_states.dart';

/// Dropdown showing all 37 Nigerian states + FCT.
/// Required for citizen registration.
class NigerianStatesDropdown extends StatelessWidget {
  const NigerianStatesDropdown({
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
          AppStrings.stateOfResidence,
          style: AppTextStyles.labelLarge.copyWith(
            color: isDark
                ? AppColors.textPrimaryDark
                : AppColors.textPrimaryLight,
          ),
        ),
        AppSpacing.gapXS,
        DropdownButtonFormField<String>(
          value: value,
          validator: validator,
          isExpanded: true,
          decoration: const InputDecoration(),
          hint: Text(
            AppStrings.selectState,
            style: TextStyle(
              color: isDark
                  ? AppColors.textHintDark
                  : AppColors.textHintLight,
            ),
          ),
          items: NigerianStates.all
              .map(
                (state) => DropdownMenuItem(
                  value: state,
                  child: Text(state),
                ),
              )
              .toList(),
          onChanged: enabled ? onChanged : null,
        ),
      ],
    );
  }
}