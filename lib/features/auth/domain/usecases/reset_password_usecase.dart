import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/auth_repository.dart';

@injectable
class ResetPasswordUseCase extends UseCase<void, ResetPasswordParams> {
  const ResetPasswordUseCase(this._repository);

  final AuthRepository _repository;

  @override
  Future<Either<Failure, void>> call(ResetPasswordParams params) {
    return _repository.resetPassword(newPassword: params.newPassword);
  }
}

class ResetPasswordParams extends Equatable {
  const ResetPasswordParams({required this.newPassword});

  final String newPassword;

  @override
  List<Object?> get props => [newPassword];
}
