import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../bloc/payment_history_event.dart';

/// Horizontal scrollable filter chips.
/// All | Paid | Pending | Failed
/// Filter applied locally — no new API call.
class FilterChipsRow extends StatelessWidget {
  const FilterChipsRow({
    super.key,
    required this.activeFilter,
    required this.onFilterChanged,
  });

  final PaymentFilter activeFilter;
  final void Function(PaymentFilter) onFilterChanged;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: PaymentFilter.values.map((filter) {
          final isActive = filter == activeFilter;
          final (label, activeColor) = switch (filter) {
            PaymentFilter.all => ('All', AppColors.primary),
            PaymentFilter.paid => ('Paid', AppColors.paid),
            PaymentFilter.pending => ('Pending', AppColors.pending),
            PaymentFilter.failed => ('Failed', AppColors.failed),
          };

          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () => onFilterChanged(filter),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: isActive
                      ? activeColor.withValues(alpha: 0.12)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isActive ? activeColor : AppColors.borderLight,
                    width: isActive ? 1.5 : 1,
                  ),
                ),
                child: Text(
                  label,
                  style: AppTextStyles.labelMedium.copyWith(
                    color: isActive ? activeColor : AppColors.grey500,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}