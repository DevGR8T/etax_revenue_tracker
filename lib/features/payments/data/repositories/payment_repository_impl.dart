import 'package:dartz/dartz.dart';
import 'package:etax_revenue_tracker/features/payments/data/models/payment_model.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/error_messages.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/services/supabase_service.dart';
import '../datasources/payment_remote_datasource.dart';
import '../models/create_payment_request_model.dart';
import '../../domain/entities/create_payment_params.dart';
import '../../domain/entities/payment_entity.dart';
import '../../domain/entities/payment_list_params.dart';
import '../../domain/entities/search_payments_params.dart';
import '../../domain/repositories/payment_repository.dart';

/// Connects payment data layer to domain layer.
///
/// SUPABASE NOTE:
/// Uses SupabaseService.getUserId() which returns a UUID String.
/// This is passed to toEntity(storedUserId) where
/// ReceiptGenerator.tinFromUuid() generates the citizen TIN.
@LazySingleton(as: PaymentRepository)
class PaymentRepositoryImpl implements PaymentRepository {
  const PaymentRepositoryImpl(
    this._remoteDataSource,
    this._supabaseService,
  );

  final PaymentRemoteDataSource _remoteDataSource;
  final SupabaseService _supabaseService;

  @override
  Future<Either<Failure, PaymentListResult>> getPayments(
    PaymentListParams params,
  ) async {
    try {
      // UUID String from Supabase — passed to toEntity for TIN generation
      final supabaseUserId = await _supabaseService.getUserId();

      final response = await _remoteDataSource.getPayments(
        limit: params.limit,
        skip: params.skip,
      );

      final payments = response.products
          .map((model) => model.toEntity(storedUserId: supabaseUserId))
          .toList();

      return Right(
        PaymentListResult(
          payments: payments,
          total: response.total,
          skip: response.skip,
          limit: response.limit,
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

  @override
  Future<Either<Failure, PaymentListResult>> searchPayments(
    SearchPaymentsParams params,
  ) async {
    try {
      final supabaseUserId = await _supabaseService.getUserId();

      final response = await _remoteDataSource.searchPayments(
        query: params.query,
        limit: params.limit,
        skip: params.skip,
      );

      final payments = response.products
          .map((model) => model.toEntity(storedUserId: supabaseUserId))
          .toList();

      return Right(
        PaymentListResult(
          payments: payments,
          total: response.total,
          skip: response.skip,
          limit: response.limit,
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

  @override
  Future<Either<Failure, PaymentEntity>> getPaymentDetail(int id) async {
    try {
      final supabaseUserId = await _supabaseService.getUserId();
      final model = await _remoteDataSource.getPaymentDetail(id);
      return Right(model.toEntity(storedUserId: supabaseUserId));
    } on NetworkException {
      return const Left(NetworkFailure());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on Exception catch (e) {
      return Left(ErrorMessages.mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, PaymentEntity>> createPayment(
    CreatePaymentParams params,
  ) async {
    try {
      final supabaseUserId = await _supabaseService.getUserId();

      final requestModel = CreatePaymentRequestModel(
        title: params.levyType,
        price: params.amount,
        category: params.assessmentYear,
        description: params.notes ?? params.levyType,
      );

      final model = await _remoteDataSource.createPayment(requestModel);
      return Right(model.toEntity(storedUserId: supabaseUserId));
    } on NetworkException {
      return const Left(NetworkFailure());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on Exception catch (e) {
      return Left(ErrorMessages.mapExceptionToFailure(e));
    }
  }
}