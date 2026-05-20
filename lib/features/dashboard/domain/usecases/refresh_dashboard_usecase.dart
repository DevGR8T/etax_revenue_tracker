import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/no_params.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/dashboard_entity.dart';
import '../repositories/dashboard_repository.dart';

/// Forces a fresh API fetch — ignores any cached data.
/// Triggered by pull-to-refresh on Dashboard screen.
@injectable
class RefreshDashboardUseCase
    extends UseCase<DashboardEntity, NoParams> {
  const RefreshDashboardUseCase(this._repository);

  final DashboardRepository _repository;

  @override
  Future<Either<Failure, DashboardEntity>> call(NoParams params) {
    return _repository.refreshDashboardData();
  }
}