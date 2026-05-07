import 'exceptions.dart';
import 'failures.dart';

/// Maps exceptions to user-friendly failures.
abstract final class ErrorMessages {
  static Failure mapExceptionToFailure(Exception exception) {
    return switch (exception) {
      NetworkException() => const NetworkFailure(),
      AuthException(:final message) => AuthFailure(message: message),
      SessionExpiredException(:final message) => AuthFailure(message: message),
      ServerException(:final message, :final statusCode) =>
        ServerFailure(message: message, statusCode: statusCode),
      CacheException(:final message) => CacheFailure(message: message),
      ValidationException(:final message) =>
        ValidationFailure(message: message),
      SecurityException(:final message) =>
        SecurityFailure(message: message),
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