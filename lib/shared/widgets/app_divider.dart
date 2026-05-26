import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

/// Consistent divider used between list items and sections.
/// Respects dark mode automatically.
class AppDivider extends StatelessWidget {
  const AppDivider({
    super.key,
    this.indent = 0,
    this.endIndent = 0,
  });

  final double indent;
  final double endIndent;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Divider(
      height: 1,
      thickness: 1,
      indent: indent,
      endIndent: endIndent,
      color: isDark ? AppColors.borderDark : AppColors.borderLight,
    );
  }
}