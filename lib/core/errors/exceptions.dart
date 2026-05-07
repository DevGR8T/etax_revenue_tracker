class ServerException implements Exception {
  const ServerException({required this.message, this.statusCode});
  final String message;
  final int? statusCode;

  @override
  String toString() => 'ServerException: $message (status: $statusCode)';
}

class NetworkException implements Exception {
  const NetworkException({this.message = 'No internet connection'});
  final String message;

  @override
  String toString() => 'NetworkException: $message';
}

class AuthException implements Exception {
  const AuthException({required this.message});
  final String message;

  @override
  String toString() => 'AuthException: $message';
}

class CacheException implements Exception {
  const CacheException({this.message = 'Cache error'});
  final String message;

  @override
  String toString() => 'CacheException: $message';
}

class ValidationException implements Exception {
  const ValidationException({required this.message});
  final String message;

  @override
  String toString() => 'ValidationException: $message';
}

class SecurityException implements Exception {
  const SecurityException({required this.message});
  final String message;

  @override
  String toString() => 'SecurityException: $message';
}

class SessionExpiredException implements Exception {
  const SessionExpiredException({this.message = 'Session has expired, please login again'});
  final String message;

  @override
  String toString() => 'SessionExpiredException: $message';
}

