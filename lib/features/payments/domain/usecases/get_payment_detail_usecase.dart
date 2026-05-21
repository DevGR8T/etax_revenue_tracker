import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/payment_entity.dart';
import '../repositories/payment_repository.dart';

@injectable
class GetPaymentDetailUseCase
    extends UseCase<PaymentEntity, GetPaymentDetailParams> {
  const GetPaymentDetailUseCase(this._repository);

  final PaymentRepository _repository;

  @override
  Future<Either<Failure, PaymentEntity>> call(
    GetPaymentDetailParams params,
  ) {
    return _repository.getPaymentDetail(params.id);
  }
}

class GetPaymentDetailParams extends Equatable {
  const GetPaymentDetailParams({required this.id});

  final int id;

  @override
  List<Object?> get props => [id];
}