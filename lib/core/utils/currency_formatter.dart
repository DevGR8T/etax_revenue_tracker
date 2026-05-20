import 'package:intl/intl.dart';

/// Formats all monetary amounts as Nigerian naira.
/// Used everywhere an amount is displayed.
abstract final class CurrencyFormatter {
  static final _formatter = NumberFormat.currency(
    locale: 'en_NG',
    symbol: '₦',
    decimalDigits: 2,
  );

  /// Format a double as ₦4,500.00
  static String format(double amount) => _formatter.format(amount);


  /// Format an int as ₦4,500.00
  static String formatInt(int amount) =>
      _formatter.format(amount.toDouble());

  /// Parse a formatted string back to double.
  /// Strips currency symbol and commas first.
  static double? parse(String value) {
    final cleaned = value
        .replaceAll('₦', '')
        .replaceAll(',', '')
        .trim();
    return double.tryParse(cleaned);
  }
}