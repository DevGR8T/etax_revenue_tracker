import '../constants/app_strings.dart';

/// Validates all user input before it reaches the network layer.
/// Returns null if valid, error message String if invalid.
abstract final class InputValidator {
  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppStrings.fieldRequired;
    }
    final regex = RegExp(r'^[\w\-.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!regex.hasMatch(value.trim())) {
      return AppStrings.invalidEmail;
    }
    return null;
  }

  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return AppStrings.fieldRequired;
    }
    if (value.length < 8) {
      return AppStrings.passwordTooShort;
    }
    if (!value.contains(RegExp(r'[0-9]'))) {
      return AppStrings.passwordNoNumber;
    }
    if (!value.contains(RegExp(r'[A-Z]'))) {
      return AppStrings.passwordNoUppercase;
    }
    return null;
  }

  static String? confirmPassword(String? value, String? original) {
    if (value == null || value.isEmpty) {
      return AppStrings.fieldRequired;
    }
    if (value != original) {
      return AppStrings.passwordsDoNotMatch;
    }
    return null;
  }

  static String? fullName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppStrings.fieldRequired;
    }
    if (value.trim().length < 2) {
      return AppStrings.fieldRequired;
    }
    return null;
  }

  static String? phoneNumber(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppStrings.fieldRequired;
    }
    final cleaned = value.trim();
    final regex = RegExp(r'^(\+234|0)(7|8|9)(0|1)\d{8}$');
    if (!regex.hasMatch(cleaned)) {
      return AppStrings.invalidPhone;
    }
    return null;
  }

  static String? required(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppStrings.fieldRequired;
    }
    return null;
  }

  static String? amount(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppStrings.fieldRequired;
    }
    final parsed = double.tryParse(value.trim().replaceAll(',', ''));
    if (parsed == null) {
      return AppStrings.invalidAmount;
    }
    if (parsed <= 0) {
      return AppStrings.amountTooLow;
    }
    if (parsed > 10000000) {
      return AppStrings.amountTooHigh;
    }
    return null;
  }

  /// Returns password strength score 0-3.
  /// 0 = empty, 1 = weak, 2 = fair, 3 = strong
  static int passwordStrength(String? value) {
    if (value == null || value.isEmpty) return 0;
    int score = 0;
    if (value.length >= 8) score++;
    if (value.contains(RegExp(r'[0-9]'))) score++;
    if (value.contains(RegExp(r'[A-Z]'))) score++;
    return score;
  }
}