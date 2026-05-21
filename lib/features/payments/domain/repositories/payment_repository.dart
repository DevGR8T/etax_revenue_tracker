import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/create_payment_params.dart';
import '../entities/payment_entity.dart';
import '../entities/payment_list_params.dart';
import '../entities/search_payments_params.dart';

/// Abstract contract for all payment operations.
/// UseCase only knows about this — never the implementation.
abstract class PaymentRepository {
  /// Paginated payment list.
  /// GET /products?limit=10&skip=0
  Future<Either<Failure, PaymentListResult>> getPayments(
    PaymentListParams params,
  );

  /// Search payments with pagination.
  /// GET /products/search?q={query}
  Future<Either<Failure, PaymentListResult>> searchPayments(
    SearchPaymentsParams params,
  );

  /// Single payment detail for receipt screen.
  /// GET /products/{id}
  Future<Either<Failure, PaymentEntity>> getPaymentDetail(int id);

  /// Create new tax payment.
  /// POST /products/add
  Future<Either<Failure, PaymentEntity>> createPayment(
    CreatePaymentParams params,
  );
}

/// Wraps the list result with pagination metadata.
/// BLoC uses total to determine if more pages exist.
class PaymentListResult {
  const PaymentListResult({
    required this.payments,
    required this.total,
    required this.skip,
    required this.limit,
  });

  final List<PaymentEntity> payments;
  final int total;
  final int skip;
  final int limit;

  /// True when all pages have been loaded.
  bool get hasReachedEnd => skip + limit >= total;
}