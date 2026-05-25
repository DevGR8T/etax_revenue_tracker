import '../constants/app_strings.dart';
import '../security/input_validator.dart';

/// Re-exports InputValidator methods as named validators.
/// Used directly in TextFormField validator parameters.
/// All validation logic lives in InputValidator — this is
/// just a convenience wrapper for form field usage.
abstract final class Validators {
  static String? Function(String?) get email =>
      InputValidator.email;

  static String? Function(String?) get password =>
      InputValidator.password;

  static String? Function(String?) get required =>
      InputValidator.required;

  static String? Function(String?) get phoneNumber =>
      InputValidator.phoneNumber;

  static String? Function(String?) get amount =>
      InputValidator.amount;

  static String? Function(String?) get fullName =>
      InputValidator.fullName;

  /// Confirm password — requires the original password value.
  static String? Function(String?) confirmPassword(
    String? originalPassword,
  ) {
    return (value) =>
        InputValidator.confirmPassword(value, originalPassword);
  }

  /// Dropdown required — validates a dropdown has a selection.
  static String? dropdownRequired(String? value) {
    if (value == null || value.isEmpty) {
      return AppStrings.fieldRequired;
    }
    return null;
  }
}