import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/auth_entity.dart';
import '../repositories/auth_repository.dart';

@injectable
class RegisterUseCase extends UseCase<AuthEntity, RegisterParams> {
  const RegisterUseCase(this._repository);

  final AuthRepository _repository;

  @override
  Future<Either<Failure, AuthEntity>> call(RegisterParams params) {
    return _repository.register(
      email: params.email,
      password: params.password,
    );
  }
}

class RegisterParams extends Equatable {
  const RegisterParams({
    required this.email,
    required this.password,
  });

  final String email;
  final String password;

  @override
  List<Object?> get props => [email, password];
}

