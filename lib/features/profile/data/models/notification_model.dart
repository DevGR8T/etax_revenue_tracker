import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/notification_entity.dart';

part 'notification_model.freezed.dart';
part 'notification_model.g.dart';

/// Maps Firestore notification document.
/// Written when FCM message received.
/// Read when citizen opens Notifications tab.
@freezed
class NotificationModel with _$NotificationModel {
  const factory NotificationModel({
    required String id,
    required String title,
    required String body,
    required DateTime timestamp,
    @Default(false) bool isRead,
    String? route,
  }) = _NotificationModel;

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationModelFromJson(json);
}

extension NotificationModelX on NotificationModel {
  NotificationEntity toEntity() => NotificationEntity(
        id: id,
        title: title,
        body: body,
        timestamp: timestamp,
        isRead: isRead,
        route: route,
      );
}

extension NotificationEntityX on NotificationEntity {
  NotificationModel toModel() => NotificationModel(
        id: id,
        title: title,
        body: body,
        timestamp: timestamp,
        isRead: isRead,
        route: route,
      );
}