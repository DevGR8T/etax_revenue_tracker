import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/dashboard_entity.dart';

/// Abstract contract for dashboard data.
/// UseCase only knows about this interface.
abstract class DashboardRepository {
  /// Fetch all dashboard data — citizen profile + recent payments.
  Future<Either<Failure, DashboardEntity>> getDashboardData();

  /// Force refresh — ignores cache, fetches fresh from API.
  Future<Either<Failure, DashboardEntity>> refreshDashboardData();
}