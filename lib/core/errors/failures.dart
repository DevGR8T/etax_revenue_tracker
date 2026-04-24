import 'package:equatable/equatable.dart';

/// All failures returned from domain layer via Either<Failure, T>.
abstract class Failure extends Equatable {
  const Failure({required this.message});
  final String message;

  @override
  List<Object?> get props => [message];
}

class ServerFailure extends Failure {
  const ServerFailure({required super.message, this.statusCode});
  final int? statusCode;

  @override
  List<Object?> get props => [message, statusCode];
}

class NetworkFailure extends Failure {
  const NetworkFailure({
    super.message = 'No internet connection',
  });
}

class AuthFailure extends Failure {
  const AuthFailure({required super.message});
}

class CacheFailure extends Failure {
  const CacheFailure({super.message = 'Local storage error'});
}

class ValidationFailure extends Failure {
  const ValidationFailure({required super.message});
}

class SecurityFailure extends Failure {
  const SecurityFailure({required super.message});
}