import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/notification_repository.dart';

@injectable
class MarkNotificationReadUseCase
    extends UseCase<void, MarkNotificationReadParams> {
  const MarkNotificationReadUseCase(this._repository);

  final NotificationRepository _repository;

  @override
  Future<Either<Failure, void>> call(MarkNotificationReadParams params) {
    return _repository.markAsRead(params.notificationId);
  }
}

class MarkNotificationReadParams extends Equatable {
  const MarkNotificationReadParams({required this.notificationId});

  final String notificationId;

  @override
  List<Object?> get props => [notificationId];
}