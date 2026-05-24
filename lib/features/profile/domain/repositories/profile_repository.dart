import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/profile_entity.dart';

abstract class ProfileRepository {
  /// Fetch citizen profile from DummyJSON users/1.
  /// Also reads Supabase email and UUID to enrich the entity.
  Future<Either<Failure, ProfileEntity>> getProfile();

  /// Force fresh fetch — ignores cache.
  Future<Either<Failure, ProfileEntity>> refreshProfile();
}