import '../date_formatter.dart';

/// Extension methods on DateTime.
extension DateTimeExtensions on DateTime {
  /// Format as Jan 5, 2024
  String get formatted => DateFormatter.format(this);

  /// Format as January 5, 2024
  String get formattedFull => DateFormatter.formatFull(this);

  /// Format as 2 hours ago
  String get timeAgo => DateFormatter.timeAgo(this);

  /// Check if date is today
  bool get isToday {
    final now = DateTime.now();
    return year == now.year &&
        month == now.month &&
        day == now.day;
  }

  /// Check if date is yesterday
  bool get isYesterday {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return year == yesterday.year &&
        month == yesterday.month &&
        day == yesterday.day;
  }
}