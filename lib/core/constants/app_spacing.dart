import 'package:flutter/material.dart';

/// Spacing constants for padding, margin, and gaps.
abstract final class AppSpacing {
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
  static const double xxl = 48.0;
  static const double xxxl = 64.0;

  static const EdgeInsets screenPadding =
      EdgeInsets.symmetric(horizontal: md, vertical: md);
  static const EdgeInsets screenHorizontal =
      EdgeInsets.symmetric(horizontal: md);
  static const EdgeInsets cardPadding = EdgeInsets.all(md);
  static const EdgeInsets cardPaddingLarge = EdgeInsets.all(lg);

  static const SizedBox gapXS = SizedBox(height: xs);
  static const SizedBox gapSM = SizedBox(height: sm);
  static const SizedBox gapMD = SizedBox(height: md);
  static const SizedBox gapLG = SizedBox(height: lg);
  static const SizedBox gapXL = SizedBox(height: xl);
  static const SizedBox gapXXL = SizedBox(height: xxl);

  static const SizedBox gapHXS = SizedBox(width: xs);
  static const SizedBox gapHSM = SizedBox(width: sm);
  static const SizedBox gapHMD = SizedBox(width: md);
  static const SizedBox gapHLG = SizedBox(width: lg);
  static const SizedBox gapHXL = SizedBox(width: xl);

  static const double radiusXS = 4.0;
  static const double radiusSM = 8.0;
  static const double radiusMD = 12.0;
  static const double radiusLG = 16.0;
  static const double radiusXL = 24.0;
  static const double radiusFull = 999.0;

  static const BorderRadius borderRadiusSM =
      BorderRadius.all(Radius.circular(radiusSM));
  static const BorderRadius borderRadiusMD =
      BorderRadius.all(Radius.circular(radiusMD));
  static const BorderRadius borderRadiusLG =
      BorderRadius.all(Radius.circular(radiusLG));
  static const BorderRadius borderRadiusFull =
      BorderRadius.all(Radius.circular(radiusFull));
}