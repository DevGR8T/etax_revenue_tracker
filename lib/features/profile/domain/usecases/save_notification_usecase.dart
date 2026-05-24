import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/notification_entity.dart';
import '../repositories/notification_repository.dart';

@injectable
class SaveNotificationUseCase extends UseCase<void, NotificationEntity> {
  const SaveNotificationUseCase(this._repository);

  final NotificationRepository _repository;

  @override
  Future<Either<Failure, void>> call(NotificationEntity params) {
    return _repository.saveNotification(params);
  }
}