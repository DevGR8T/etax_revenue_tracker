import 'package:equatable/equatable.dart';
import '../../domain/entities/auth_entity.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

/// Initial — no auth check done yet.
class AuthInitialState extends AuthState {
  const AuthInitialState();
}

/// Auth operation in progress — UI shows spinner.
class AuthLoadingState extends AuthState {
  const AuthLoadingState();
}

/// Citizen is authenticated — GoRouter routes to Dashboard.
class AuthenticatedState extends AuthState {
  const AuthenticatedState({required this.entity});

  final AuthEntity entity;

  @override
  List<Object?> get props => [entity];
}

/// Not authenticated — GoRouter routes to Login.
class UnauthenticatedState extends AuthState {
  const UnauthenticatedState();
}

/// Auth operation failed — UI shows error snackbar.
class AuthErrorState extends AuthState {
  const AuthErrorState({required this.message});

  final String message;

  @override
  List<Object?> get props => [message];
}