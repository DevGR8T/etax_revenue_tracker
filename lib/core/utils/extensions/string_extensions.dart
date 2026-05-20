/// Extension methods on String.
/// Used for initials, capitalization, and display formatting.
extension StringExtensions on String {
  /// Get initials from a full name.
  /// "John Doe" → "JD"
  /// "John" → "J"
  String get initials {
    final parts = trim().split(' ').where((p) => p.isNotEmpty).toList();
    if (parts.isEmpty) return '';
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return '${parts[0][0]}${parts[parts.length - 1][0]}'.toUpperCase();
  }

  /// Capitalize first letter only.
  String get capitalized {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1).toLowerCase()}';
  }

  /// Truncate string to max length with ellipsis.
  String truncate(int maxLength) {
  if (length <= maxLength) return this;
  return '${substring(0, lastIndexOf(' ', maxLength))}...';
}

  /// Check if string is a valid email.
  bool get isValidEmail {
    final regex = RegExp(r'^[\w\-.]+@([\w-]+\.)+[\w-]{2,4}$');
    return regex.hasMatch(this);
  }
}