import 'package:dartz/dartz.dart';
import 'package:etax_revenue_tracker/features/profile/data/models/profile_model.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/error_messages.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/services/supabase_service.dart';
import '../../domain/entities/profile_entity.dart';
import '../../domain/repositories/profile_repository.dart';
import '../datasources/profile_local_datasource.dart';
import '../datasources/profile_remote_datasource.dart';

/// Connects profile data layer to domain layer.
///
/// SUPABASE NOTE:
/// Three data sources run simultaneously via Future.wait:
/// 1. DummyJSON for profile display data (name, phone, avatar)
/// 2. SharedPreferences for state of residence
/// 3. SupabaseService for real UUID and real email
///
/// The Supabase email overrides the DummyJSON email because
/// the citizen registered with their real email in Supabase.
/// The Supabase UUID is used for TIN generation.
@LazySingleton(as: ProfileRepository)
class ProfileRepositoryImpl implements ProfileRepository {
  const ProfileRepositoryImpl(
    this._remoteDataSource,
    this._localDataSource,
    this._supabaseService,
  );

  final ProfileRemoteDataSource _remoteDataSource;
  final ProfileLocalDataSource _localDataSource;
  final SupabaseService _supabaseService;

  @override
  Future<Either<Failure, ProfileEntity>> getProfile() => _fetchProfile();

  @override
  Future<Either<Failure, ProfileEntity>> refreshProfile() => _fetchProfile();

  Future<Either<Failure, ProfileEntity>> _fetchProfile() async {
    try {
      // Three sources run simultaneously — not sequentially
      final results = await Future.wait([
        _remoteDataSource.getProfile(),
        _localDataSource.getStateOfResidence(),
        _supabaseService.getUserId(),
        _supabaseService.getUserEmail(),
      ]);

      final model = results[0] as ProfileModel;
      final stateOfResidence = results[1] as String?;
      final supabaseUserId = results[2] as String?;
      final supabaseEmail = results[3] as String?;

      return Right(
        model.toEntity(
          stateOfResidence: stateOfResidence,
          supabaseUserId: supabaseUserId,
          supabaseEmail: supabaseEmail,
        ),
      );
    } on NetworkException {
      return const Left(NetworkFailure());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on Exception catch (e) {
      return Left(ErrorMessages.mapExceptionToFailure(e));
    }
  }
}