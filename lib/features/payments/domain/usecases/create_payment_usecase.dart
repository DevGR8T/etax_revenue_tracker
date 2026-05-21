import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/create_payment_params.dart';
import '../entities/payment_entity.dart';
import '../repositories/payment_repository.dart';

@injectable
class CreatePaymentUseCase
    extends UseCase<PaymentEntity, CreatePaymentParams> {
  const CreatePaymentUseCase(this._repository);

  final PaymentRepository _repository;

  @override
  Future<Either<Failure, PaymentEntity>> call(
    CreatePaymentParams params,
  ) {
    return _repository.createPayment(params);
  }
}