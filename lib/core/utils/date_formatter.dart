import 'package:intl/intl.dart';

/// Formats all dates consistently across the app.
abstract final class DateFormatter {
  static final _displayFormat = DateFormat('MMM d, yyyy');
  static final _fullFormat = DateFormat('MMMM d, yyyy');
  static final _timeFormat = DateFormat('h:mm a');

  /// Format DateTime as Jan 5, 2024
  static String format(DateTime date) => _displayFormat.format(date);

  /// Format DateTime as January 5, 2024
  static String formatFull(DateTime date) => _fullFormat.format(date);

  /// Format DateTime as 2:30 PM
  static String formatTime(DateTime date) => _timeFormat.format(date);

  /// Format as relative time — 2 hours ago, 3 days ago.
  static String timeAgo(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inSeconds < 60) return 'Just now';
    if (difference.inMinutes < 60) {
      final m = difference.inMinutes;
      return '$m ${m == 1 ? 'minute' : 'minutes'} ago';
    }
    if (difference.inHours < 24) {
      final h = difference.inHours;
      return '$h ${h == 1 ? 'hour' : 'hours'} ago';
    }
    if (difference.inDays < 7) {
      final d = difference.inDays;
      return '$d ${d == 1 ? 'day' : 'days'} ago';
    }
    if (difference.inDays < 30) {
      final w = (difference.inDays / 7).floor();
      return '$w ${w == 1 ? 'week' : 'weeks'} ago';
    }
    return format(date);
  }

  /// Parse ISO string to DateTime safely.
  /// Returns DateTime.now() as fallback if parsing fails.
  static DateTime parseOrNow(String? isoString) {
    if (isoString == null) return DateTime.now();
    try {
      return DateTime.parse(isoString);
    } catch (_) {
      return DateTime.now();
    }
  }
}