import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';

/// Search bar with clear button.
/// Debounce is handled in the BLoC — not here.
/// This widget fires onChanged on every keystroke.
class PaymentSearchBar extends StatefulWidget {
  const PaymentSearchBar({
    super.key,
    required this.onChanged,
    required this.onClear,
    this.hint = 'Search payments...',
  });

  final void Function(String) onChanged;
  final VoidCallback onClear;
  final String hint;

  @override
  State<PaymentSearchBar> createState() => _PaymentSearchBarState();
}

class _PaymentSearchBarState extends State<PaymentSearchBar> {
  final _controller = TextEditingController();
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      setState(() => _hasText = _controller.text.isNotEmpty);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _clear() {
    _controller.clear();
    widget.onClear();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      height: 46,
      decoration: BoxDecoration(
        color: isDark ? AppColors.grey800 : AppColors.grey100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        controller: _controller,
        onChanged: widget.onChanged,
        style: AppTextStyles.bodyMedium,
        decoration: InputDecoration(
          hintText: widget.hint,
          hintStyle: AppTextStyles.bodyMedium.copyWith(
            color: isDark ? AppColors.textHintDark : AppColors.textHintLight,
          ),
          prefixIcon: Icon(
            Icons.search_rounded,
            size: 20,
            color: isDark ? AppColors.textSecondaryDark : AppColors.grey400,
          ),
          suffixIcon: _hasText
              ? IconButton(
                  icon: Icon(
                    Icons.close_rounded,
                    size: 18,
                    color: isDark
                        ? AppColors.textSecondaryDark
                        : AppColors.grey400,
                  ),
                  onPressed: _clear,
                )
              : null,
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 13,
          ),
          filled: false,
        ),
      ),
    );
  }
}