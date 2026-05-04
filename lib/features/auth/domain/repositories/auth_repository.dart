import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/auth_entity.dart';

abstract class AuthRepository {
  /// Register a new citizen account with email and password.
  Future<Either<Failure, AuthEntity>> register({
    required String email,
    required String password,
  });

  /// Login with email and password.
  Future<Either<Failure, AuthEntity>> login({
    required String email,
    required String password,
  });

  /// Logout — invalidates token on Supabase and clears local storage.
  Future<Either<Failure, void>> logout();

  /// Send password reset email via Supabase.
  Future<Either<Failure, void>> sendPasswordResetLink({
    required String email,
  });

  /// Reset password with new value.
  Future<Either<Failure, void>> resetPassword({
    required String newPassword,
  });

  /// Check if a valid token exists in secure storage.
  Future<bool> isLoggedIn();

  /// Get the stored access token.
  Future<String?> getAccessToken();

  /// Get the stored user ID.
  Future<String?> getUserId();
}