import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';

/// Circular avatar showing citizen initials.
/// Used in Profile screen header and AppBar.
/// Falls back to initials when no photo available.
class AvatarCircle extends StatelessWidget {
  const AvatarCircle({
    super.key,
    required this.initials,
    this.radius = 40,
    this.avatarUrl,
    this.backgroundColor,
  });

  final String initials;
  final double radius;
  final String? avatarUrl;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    if (avatarUrl != null && avatarUrl!.isNotEmpty) {
      return CircleAvatar(
        radius: radius,
        backgroundImage: NetworkImage(avatarUrl!),
        onBackgroundImageError: (_, _) {},
        child: null,
      );
    }

    return CircleAvatar(
      radius: radius,
      backgroundColor:
          backgroundColor ?? AppColors.primary.withValues(alpha: 0.15),
      child: Text(
        initials,
        style: AppTextStyles.h3.copyWith(
          color: backgroundColor != null
              ? AppColors.white
              : AppColors.primary,
          fontSize: radius * 0.5,
        ),
      ),
    );
  }
}