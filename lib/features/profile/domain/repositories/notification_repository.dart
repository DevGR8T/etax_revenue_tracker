import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/notification_entity.dart';

abstract class NotificationRepository {
  /// Fetch all notifications for current citizen from Firestore.
  Future<Either<Failure, List<NotificationEntity>>> getNotifications();

  /// Mark a single notification as read.
  Future<Either<Failure, void>> markAsRead(String notificationId);

  /// Mark all notifications as read.
  Future<Either<Failure, void>> markAllAsRead();

  /// Get count of unread notifications.
  Future<Either<Failure, int>> getUnreadCount();

  /// Save a new notification received from FCM.
  Future<Either<Failure, void>> saveNotification(
    NotificationEntity notification,
  );
}