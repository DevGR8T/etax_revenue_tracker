import 'exceptions.dart';
import 'failures.dart';

/// Maps exceptions to user-friendly failures.
abstract final class ErrorMessages {
  static const String emailConfirmationRequired =
      'Please check your email to confirm your account.';
  static const String registrationFailed =
      'Registration failed. Please try again.';
  static const String loginFailed = 'Login failed. Please try again.';
  static const String logoutFailed = 'Logout failed.';
  static const String passwordResetFailed = 'Password reset failed.';
  static const String resetLinkFailed = 'Failed to send reset link.';
  static String fromSupabaseErrorCode(String? errorCode) {
    return switch (errorCode) {
      'invalid_credentials' =>
        'Invalid email or password. Please check and try again.',
      'user_already_exists' =>
        'This email is already registered. Please sign in instead.',
      'weak_password' =>
        'Password is too weak. Use at least 8 characters with a number and uppercase letter.',
      'email_not_confirmed' => 'Please verify your email before signing in.',
      'over_email_send_rate_limit' =>
        'Too many attempts. Please wait a few minutes and try again.',
      _ => 'Authentication failed. Please try again.',
    };
  }

  static Failure mapExceptionToFailure(Exception exception) {
    return switch (exception) {
      NetworkException() => const NetworkFailure(),
      AuthException(:final message) => AuthFailure(message: message),
      SessionExpiredException(:final message) => AuthFailure(message: message),
      ServerException(:final message, :final statusCode) => ServerFailure(
        message: message,
        statusCode: statusCode,
      ),
      CacheException(:final message) => CacheFailure(message: message),
      ValidationException(:final message) => ValidationFailure(
        message: message,
      ),
      SecurityException(:final message) => SecurityFailure(message: message),
      _ => const ServerFailure(message: 'An unexpected error occurred'),
    };
  }

  /// Maps HTTP status codes to user-friendly messages.

  static String fromStatusCode(int statusCode) {
    return switch (statusCode) {
      400 => 'Bad request. Please check your input.',
      401 => 'Session expired. Please login again.',
      403 => 'You do not have permission to perform this action.',
      404 => 'The requested resource was not found.',
      408 => 'Request timed out. Please try again.',
      429 => 'Too many requests. Please wait and try again.',
      500 => 'Server error. Please try again later.',
      503 => 'Service unavailable. Please try again later.',
      _ => 'An unexpected error occurred.',
    };
  }
}
