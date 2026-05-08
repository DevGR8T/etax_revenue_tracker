import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/auth_repository.dart';

@injectable
class SendResetLinkUseCase extends UseCase<void, SendResetLinkParams> {
  const SendResetLinkUseCase(this._repository);

  final AuthRepository _repository;

  @override
  Future<Either<Failure, void>> call(SendResetLinkParams params) {
    return _repository.sendPasswordResetLink(email: params.email);
  }
}

class SendResetLinkParams extends Equatable {
  const SendResetLinkParams({required this.email});

  final String email;

  @override
  List<Object?> get props => [email];
}