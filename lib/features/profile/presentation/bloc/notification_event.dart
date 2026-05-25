import 'package:equatable/equatable.dart';

abstract class NotificationEvent extends Equatable {
  const NotificationEvent();

  @override
  List<Object?> get props => [];
}

class LoadNotificationsEvent extends NotificationEvent {
  const LoadNotificationsEvent();
}

class MarkNotificationReadEvent extends NotificationEvent {
  const MarkNotificationReadEvent({required this.notificationId});

  final String notificationId;

  @override
  List<Object?> get props => [notificationId];
}

class MarkAllNotificationsReadEvent extends NotificationEvent {
  const MarkAllNotificationsReadEvent();
}

class RefreshUnreadCountEvent extends NotificationEvent {
  const RefreshUnreadCountEvent();
}