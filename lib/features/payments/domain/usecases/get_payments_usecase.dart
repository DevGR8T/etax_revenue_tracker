import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/payment_list_params.dart';
import '../repositories/payment_repository.dart';

@injectable
class GetPaymentsUseCase extends UseCase<PaymentListResult, PaymentListParams> {
  const GetPaymentsUseCase(this._repository);

  final PaymentRepository _repository;

  @override
  Future<Either<Failure, PaymentListResult>> call(PaymentListParams params) {
    return _repository.getPayments(params);
  }
}