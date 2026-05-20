import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

/// Centered loading indicator.
/// Used for full-screen loading states.
class AppLoadingWidget extends StatelessWidget {
  const AppLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
      ),
    );
  }
}