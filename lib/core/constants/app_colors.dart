import 'package:flutter/material.dart';

/// All colors used across the eTax Revenue Tracker app.

abstract final class AppColors {
  // ── Brand ──────────────────────────────────────────────────
  static const Color primary = Color(0xFF1A6B3A);
  static const Color primaryLight = Color(0xFF2E8B57);
  static const Color primaryDark = Color(0xFF0F4D28);
  static const Color secondary = Color(0xFF2B5FA8);
  static const Color secondaryLight = Color(0xFF3D74C7);
  static const Color secondaryDark = Color(0xFF1A3F7A);

  // ── Payment Status ─────────────────────────────────────────
  static const Color paid = Color(0xFF16A34A);
  static const Color paidBackground = Color(0xFFDCFCE7);
  static const Color paidText = Color(0xFF14532D);
  static const Color pending = Color(0xFFD97706);
  static const Color pendingBackground = Color(0xFFFEF3C7);
  static const Color pendingText = Color(0xFF78350F);
  static const Color failed = Color(0xFFDC2626);
  static const Color failedBackground = Color(0xFFFEE2E2);
  static const Color failedText = Color(0xFF7F1D1D);

  // ── Neutrals ───────────────────────────────────────────────
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color grey50 = Color(0xFFF8FAFC);
  static const Color grey100 = Color(0xFFF1F5F9);
  static const Color grey200 = Color(0xFFE2E8F0);
  static const Color grey300 = Color(0xFFCBD5E1);
  static const Color grey400 = Color(0xFF94A3B8);
  static const Color grey500 = Color(0xFF64748B);
  static const Color grey600 = Color(0xFF475569);
  static const Color grey700 = Color(0xFF334155);
  static const Color grey800 = Color(0xFF1E293B);
  static const Color grey900 = Color(0xFF0F172A);

  // ── Backgrounds ────────────────────────────────────────────
  static const Color backgroundLight = Color(0xFFF8FAFC);
  static const Color backgroundDark = Color(0xFF0F172A);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color surfaceDark = Color(0xFF1E293B);
  static const Color cardLight = Color(0xFFFFFFFF);
  static const Color cardDark = Color(0xFF1E293B);

  // ── Text ───────────────────────────────────────────────────
  static const Color textPrimaryLight = Color(0xFF0F172A);
  static const Color textPrimaryDark = Color(0xFFF8FAFC);
  static const Color textSecondaryLight = Color(0xFF475569);
  static const Color textSecondaryDark = Color(0xFF94A3B8);
  static const Color textHintLight = Color(0xFF94A3B8);
  static const Color textHintDark = Color(0xFF475569);

  // ── Border ─────────────────────────────────────────────────
  static const Color borderLight = Color(0xFFE2E8F0);
  static const Color borderDark = Color(0xFF334155);

  // ── Error ──────────────────────────────────────────────────
  static const Color error = Color(0xFFDC2626);
  static const Color errorBackground = Color(0xFFFEE2E2);

  // ── TIN Card ───────────────────────────────────────────────
  static const Color tinCardGradientStart = Color(0xFF1A6B3A);
  static const Color tinCardGradientEnd = Color(0xFF2B5FA8);

  // ── Shimmer ────────────────────────────────────────────────
  static const Color shimmerBase = Color(0xFFE2E8F0);
  static const Color shimmerHighlight = Color(0xFFF8FAFC);
  static const Color shimmerBaseDark = Color(0xFF334155);
  static const Color shimmerHighlightDark = Color(0xFF475569);
}