import 'package:equatable/equatable.dart';
import '../../domain/entities/notification_entity.dart';

abstract class NotificationState extends Equatable {
  const NotificationState();

  @override
  List<Object?> get props => [];
}

class NotificationInitialState extends NotificationState {
  const NotificationInitialState();
}

class NotificationLoadingState extends NotificationState {
  const NotificationLoadingState();
}

class NotificationLoadedState extends NotificationState {
  const NotificationLoadedState({
    required this.notifications,
    required this.unreadCount,
  });

  final List<NotificationEntity> notifications;
  final int unreadCount;

  @override
  List<Object?> get props => [notifications, unreadCount];
}

class NotificationErrorState extends NotificationState {
  const NotificationErrorState({required this.message});

  final String message;

  @override
  List<Object?> get props => [message];
}

class NotificationEmptyState extends NotificationState {
  const NotificationEmptyState();
}