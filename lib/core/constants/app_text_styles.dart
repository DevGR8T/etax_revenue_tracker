import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// All text styles used across the app.
/// Never define TextStyle inline in widgets.
abstract final class AppTextStyles {
  static TextStyle displayLarge = GoogleFonts.inter(
    fontSize: 32, fontWeight: FontWeight.w700, letterSpacing: -0.5,
  );
  static TextStyle h1 = GoogleFonts.inter(
    fontSize: 24, fontWeight: FontWeight.w700, letterSpacing: -0.3,
  );
  static TextStyle h2 = GoogleFonts.inter(
    fontSize: 20, fontWeight: FontWeight.w600, letterSpacing: -0.2,
  );
  static TextStyle h3 = GoogleFonts.inter(
    fontSize: 18, fontWeight: FontWeight.w600,
  );
  static TextStyle h4 = GoogleFonts.inter(
    fontSize: 16, fontWeight: FontWeight.w600,
  );
  static TextStyle bodyLarge = GoogleFonts.inter(
    fontSize: 16, fontWeight: FontWeight.w400, height: 1.6,
  );
  static TextStyle bodyMedium = GoogleFonts.inter(
    fontSize: 14, fontWeight: FontWeight.w400, height: 1.5,
  );
  static TextStyle bodySmall = GoogleFonts.inter(
    fontSize: 12, fontWeight: FontWeight.w400, height: 1.5,
  );
  static TextStyle labelLarge = GoogleFonts.inter(
    fontSize: 14, fontWeight: FontWeight.w500, letterSpacing: 0.1,
  );
  static TextStyle labelMedium = GoogleFonts.inter(
    fontSize: 12, fontWeight: FontWeight.w500, letterSpacing: 0.1,
  );
  static TextStyle labelSmall = GoogleFonts.inter(
  fontSize: 11, fontWeight: FontWeight.w500, letterSpacing: 0.1,
);
  static TextStyle button = GoogleFonts.inter(
    fontSize: 16, fontWeight: FontWeight.w600, letterSpacing: 0.2,
  );
  static TextStyle caption = GoogleFonts.inter(
    fontSize: 12, fontWeight: FontWeight.w400, color: AppColors.grey500,
  );

  // ── Receipt specific ───────────────────────────────────────
  static TextStyle receiptAmount = GoogleFonts.inter(
    fontSize: 36, fontWeight: FontWeight.w700, letterSpacing: -1,
  );
  static TextStyle receiptLabel = GoogleFonts.inter(
    fontSize: 12, fontWeight: FontWeight.w400, color: AppColors.grey500,
  );
  static TextStyle receiptValue = GoogleFonts.inter(
    fontSize: 14, fontWeight: FontWeight.w500,
  );
  static TextStyle receiptNumber = GoogleFonts.sourceCodePro(
    fontSize: 13, fontWeight: FontWeight.w500, letterSpacing: 0.5,
  );

  // ── TIN Card ───────────────────────────────────────────────
  static TextStyle tinNumber = GoogleFonts.sourceCodePro(
    fontSize: 16, fontWeight: FontWeight.w600,
    color: AppColors.white, letterSpacing: 1.5,
  );
  static TextStyle tinLabel = GoogleFonts.inter(
    fontSize: 11, fontWeight: FontWeight.w400,
    color: AppColors.white, letterSpacing: 0.5,
  );
}