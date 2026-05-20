import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/error_messages.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/services/supabase_service.dart';
import '../../../../core/utils/receipt_generator.dart';
import '../../domain/entities/dashboard_entity.dart';
import '../../domain/entities/recent_payment_entity.dart';
import '../../domain/repositories/dashboard_repository.dart';
import '../datasources/dashboard_remote_datasource.dart';
import '../models/dashboard_user_model.dart';
import '../models/recent_payment_model.dart';

/// Connects dashboard data layer to domain layer.
/// Runs two API calls simultaneously via Future.wait.
///
/// SUPABASE NOTE:
/// getUserId() now returns a UUID String from Supabase —
/// not an int like ReqRes. We use ReceiptGenerator.tinFromUuid()
/// to generate a stable 8-digit TIN from the UUID.
@LazySingleton(as: DashboardRepository)
class DashboardRepositoryImpl implements DashboardRepository {
  const DashboardRepositoryImpl(
    this._remoteDataSource,
    this._supabaseService,
  );

  final DashboardRemoteDataSource _remoteDataSource;
  final SupabaseService _supabaseService;

  @override
  Future<Either<Failure, DashboardEntity>> getDashboardData() =>
      _fetchData();

  @override
  Future<Either<Failure, DashboardEntity>> refreshDashboardData() =>
      _fetchData();

  Future<Either<Failure, DashboardEntity>> _fetchData() async {
    try {
      // Both API calls fire simultaneously — not sequentially.
      // Total wait = slower of the two, not sum of both.
      final results = await Future.wait([
        _remoteDataSource.getUser(),
        _remoteDataSource.getRecentPayments(),
      ]);

      final user = results[0] as DashboardUserModel;
      final productsResponse = results[1] as ProductsListModel;

      // Get Supabase UUID for TIN generation
      // Falls back to DummyJSON user id if Supabase session not found
      final supabaseUserId = await _supabaseService.getUserId();

      final tin = supabaseUserId != null && supabaseUserId.isNotEmpty
          ? ReceiptGenerator.tinFromUuid(supabaseUserId)
          : ReceiptGenerator.tin(user.id);

      // Convert payment models to entities
      final recentPayments = productsResponse.products
          .map((p) => p.toEntity())
          .toList();

      // Calculate stats from payment list
      final paidPayments = recentPayments
          .where((p) => p.status == PaymentStatus.paid)
          .toList();

      final pendingPayments = recentPayments
          .where((p) => p.status == PaymentStatus.pending)
          .toList();

      final totalPaid = paidPayments.fold<double>(
        0,
        (sum, p) => sum + p.amount,
      );

      final outstanding = pendingPayments.fold<double>(
        0,
        (sum, p) => sum + p.amount,
      );

      final entity = DashboardEntity(
        citizenName: '${user.firstName} ${user.lastName}',
        tin: tin,
        totalPaid: totalPaid,
        outstanding: outstanding,
        receiptCount: productsResponse.total,
        recentPayments: recentPayments,
      );

      return Right(entity);
    } on NetworkException {
      return const Left(NetworkFailure());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on Exception catch (e) {
      return Left(ErrorMessages.mapExceptionToFailure(e));
    }
  }
}