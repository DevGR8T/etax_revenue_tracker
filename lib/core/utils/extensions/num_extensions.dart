import '../currency_formatter.dart';

/// Extension methods on num types.
extension NumExtensions on num {
  /// Format as Nigerian naira — ₦4,500.00
  String get toNaira => CurrencyFormatter.format(toDouble());

  /// Check if value is a valid positive amount.
  bool get isValidAmount => this > 0 && this <= 10000000;
}