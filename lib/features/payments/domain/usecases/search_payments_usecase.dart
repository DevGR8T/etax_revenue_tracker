import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/search_payments_params.dart';
import '../repositories/payment_repository.dart';

@injectable
class SearchPaymentsUseCase
    extends UseCase<PaymentListResult, SearchPaymentsParams> {
  const SearchPaymentsUseCase(this._repository);

  final PaymentRepository _repository;

  @override
  Future<Either<Failure, PaymentListResult>> call(
    SearchPaymentsParams params,
  ) {
    return _repository.searchPayments(params);
  }
}