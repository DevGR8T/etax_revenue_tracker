import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supa;
import '../../../../core/errors/error_messages.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/network_info.dart';
import '../../../../core/services/supabase_service.dart';
import '../models/auth_response_model.dart';

/// Mirrors the Supabase Postman requests exactly.
/// This is the ONLY place that knows about Supabase SDK.
/// Throws typed exceptions — never raw AuthException from SDK.
abstract class AuthRemoteDataSource {
  Future<AuthResponseModel> register({
    required String email,
    required String password,
  });

  Future<AuthResponseModel> login({
    required String email,
    required String password,
  });

  Future<void> logout();

  Future<void> sendPasswordResetLink({required String email});

  Future<void> resetPassword({required String newPassword});
}

@LazySingleton(as: AuthRemoteDataSource)
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  AuthRemoteDataSourceImpl(
    this._supabaseService,
    this._networkInfo,
  );

  final SupabaseService _supabaseService;
  final NetworkInfo _networkInfo;

  @override
  Future<AuthResponseModel> register({
    required String email,
    required String password,
  }) async {
    if (!await _networkInfo.isConnected) {
      throw const NetworkException();
    }

    try {
      final response = await _supabaseService.signUp(
        email: email,
        password: password,
      );

      // session is null if email confirmation is required
      if (response.session == null) {
        throw const AuthException(
          message:  ErrorMessages.emailConfirmationRequired,
        );
      }

      // Save session to SecureStorage
      await _supabaseService.saveSession(response.session!);

      return AuthResponseModel.fromSupabaseResponse(response);
    } on supa.AuthException catch (e) {
      // Supabase SDK throws AuthException with error_code field
      final message = ErrorMessages.fromSupabaseErrorCode(e.code);
      throw AuthException(message: message);
    } catch (e) {
      if (e is AuthException || e is NetworkException) rethrow;
      throw const ServerException(message: ErrorMessages.registrationFailed);
    }
  }

  @override
  Future<AuthResponseModel> login({
    required String email,
    required String password,
  }) async {
    if (!await _networkInfo.isConnected) {
      throw const NetworkException();
    }

    try {
      final response = await _supabaseService.signIn(
        email: email,
        password: password,
      );

      if (response.session == null) {
        throw const AuthException(message: ErrorMessages.loginFailed);
      }

      // Save session to SecureStorage
      await _supabaseService.saveSession(response.session!);

      return AuthResponseModel.fromSupabaseResponse(response);
    } on supa.AuthException catch (e) {
      final message = ErrorMessages.fromSupabaseErrorCode(e.code);
      throw AuthException(message: message);
    } catch (e) {
      if (e is AuthException || e is NetworkException) rethrow;
      throw const ServerException(message: ErrorMessages.loginFailed);
    }
  }

  @override
  Future<void> logout() async {
    if (!await _networkInfo.isConnected) {
      throw const NetworkException();
    }

    try {
      await _supabaseService.signOut();
    } on supa.AuthException catch (e) {
      throw AuthException(message: e.message);
    } catch (e) {
      if (e is AuthException || e is NetworkException) rethrow;
      throw const ServerException(message: ErrorMessages.logoutFailed);
    }
  }

  @override
  Future<void> sendPasswordResetLink({required String email}) async {
    if (!await _networkInfo.isConnected) {
      throw const NetworkException();
    }

    try {
      await _supabaseService.sendPasswordResetEmail(email: email);
    } on supa.AuthException catch (e) {
      throw AuthException(message: e.message);
    } catch (e) {
      if (e is AuthException || e is NetworkException) rethrow;
      throw const ServerException(message: ErrorMessages.resetLinkFailed);
    }
  }

  @override
  Future<void> resetPassword({required String newPassword}) async {
    if (!await _networkInfo.isConnected) {
      throw const NetworkException();
    }

    try {
      await _supabaseService.updatePassword(newPassword: newPassword);
    } on supa.AuthException catch (e) {
      throw AuthException(message: e.message);
    } catch (e) {
      if (e is AuthException || e is NetworkException) rethrow;
      throw const ServerException(message: ErrorMessages.passwordResetFailed);
    }
  }
}