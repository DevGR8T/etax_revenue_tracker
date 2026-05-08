import 'package:dartz/dartz.dart';
import 'package:etax_revenue_tracker/features/auth/data/models/auth_response_model.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/error_messages.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/auth_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_datasource.dart';
import '../datasources/auth_remote_datasource.dart';

/// Connects data layer to domain layer.
/// Converts models to entities.
/// Converts exceptions to Failures.
@LazySingleton(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl(
    this._remoteDataSource,
    this._localDataSource,
  );

  final AuthRemoteDataSource _remoteDataSource;
  final AuthLocalDataSource _localDataSource;

  @override
  Future<Either<Failure, AuthEntity>> register({
    required String email,
    required String password,
  }) async {
    try {
      final model = await _remoteDataSource.register(
        email: email,
        password: password,
      );
      return Right(model.toEntity());
    } on NetworkException {
      return const Left(NetworkFailure());
    } on AuthException catch (e) {
      return Left(AuthFailure(message: e.message));
    } on Exception catch (e) {
      return Left(ErrorMessages.mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, AuthEntity>> login({
    required String email,
    required String password,
  }) async {
    try {
      final model = await _remoteDataSource.login(
        email: email,
        password: password,
      );
      return Right(model.toEntity());
    } on NetworkException {
      return const Left(NetworkFailure());
    } on AuthException catch (e) {
      return Left(AuthFailure(message: e.message));
    } on Exception catch (e) {
      return Left(ErrorMessages.mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await _remoteDataSource.logout();
      await _localDataSource.clearAuth();
      return const Right(null);
    } on NetworkException {
      // Even if network fails, clear local session
      await _localDataSource.clearAuth();
      return const Right(null);
    } on AuthException catch (e) {
      return Left(AuthFailure(message: e.message));
    } on Exception catch (e) {
      return Left(ErrorMessages.mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, void>> sendPasswordResetLink({
    required String email,
  }) async {
    try {
      await _remoteDataSource.sendPasswordResetLink(email: email);
      return const Right(null);
    } on NetworkException {
      return const Left(NetworkFailure());
    } on AuthException catch (e) {
      return Left(AuthFailure(message: e.message));
    } on Exception catch (e) {
      return Left(ErrorMessages.mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, void>> resetPassword({
    required String newPassword,
  }) async {
    try {
      await _remoteDataSource.resetPassword(newPassword: newPassword);
      return const Right(null);
    } on NetworkException {
      return const Left(NetworkFailure());
    } on AuthException catch (e) {
      return Left(AuthFailure(message: e.message));
    } on Exception catch (e) {
      return Left(ErrorMessages.mapExceptionToFailure(e));
    }
  }

  @override
  Future<bool> isLoggedIn() async {
    return _localDataSource.isLoggedIn();
  }

  @override
  Future<String?> getAccessToken() async {
    return _localDataSource.getAccessToken();
  }

  @override
  Future<String?> getUserId() async {
    return _localDataSource.getUserId();
  }
}