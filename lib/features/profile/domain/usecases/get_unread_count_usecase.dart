import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/no_params.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/notification_repository.dart';

@injectable
class GetUnreadCountUseCase extends UseCase<int, NoParams> {
  const GetUnreadCountUseCase(this._repository);

  final NotificationRepository _repository;

  @override
  Future<Either<Failure, int>> call(NoParams params) {
    return _repository.getUnreadCount();
  }
}