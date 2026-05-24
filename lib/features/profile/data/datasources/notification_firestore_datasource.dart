import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/services/supabase_service.dart';
import '../models/notification_model.dart';

/// Reads and writes notifications to Firestore.
///
/// Collection path: notifications/{supabaseUserId}/messages/{docId}
///
/// SUPABASE NOTE:
/// Uses SupabaseService.getUserId() which returns UUID String.
/// UUID String is a valid Firestore document path segment.
/// Each citizen's notifications are completely isolated
/// by their Supabase UUID — same security model as before
/// but now using the real Supabase UUID instead of a fake ReqRes id.
///
/// Firestore security rules enforce:
/// request.auth.uid == supabaseUserId
/// This requires Firebase Auth to be synced with Supabase Auth
abstract class NotificationFirestoreDataSource {
  Future<List<NotificationModel>> getNotifications();
  Future<void> markAsRead(String notificationId);
  Future<void> markAllAsRead();
  Future<int> getUnreadCount();
  Future<void> saveNotification(NotificationModel notification);
}

@LazySingleton(as: NotificationFirestoreDataSource)
class NotificationFirestoreDataSourceImpl
    implements NotificationFirestoreDataSource {
  NotificationFirestoreDataSourceImpl(
    this._firestore,
    this._supabaseService,
  );

  final FirebaseFirestore _firestore;
  final SupabaseService _supabaseService;

  /// Build collection reference for current citizen.
  /// Uses Supabase UUID — valid Firestore path segment.
  Future<CollectionReference> get _collection async {
    final userId =
        await _supabaseService.getUserId() ?? 'unknown';
    return _firestore
        .collection('notifications')
        .doc(userId)
        .collection('messages');
  }

  @override
  Future<List<NotificationModel>> getNotifications() async {
    try {
      final collection = await _collection;
      final snapshot = await collection
          .orderBy('timestamp', descending: true)
          .limit(50)
          .get();

      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;

        // Convert Firestore Timestamp to ISO string for json_serializable
        if (data['timestamp'] is Timestamp) {
          data['timestamp'] =
              (data['timestamp'] as Timestamp).toDate().toIso8601String();
        }

        return NotificationModel.fromJson(data);
      }).toList();
    } on FirebaseException catch (e) {
      throw ServerException(
        message: e.message ?? 'Could not load notifications',
        statusCode: null,
      );
    }
  }

  @override
  Future<void> markAsRead(String notificationId) async {
    try {
      final collection = await _collection;
      await collection.doc(notificationId).update({'isRead': true});
    } on FirebaseException catch (e) {
      throw ServerException(
        message: e.message ?? 'Could not mark notification as read',
        statusCode: null,
      );
    }
  }

  @override
  Future<void> markAllAsRead() async {
    try {
      final collection = await _collection;
      final snapshot =
          await collection.where('isRead', isEqualTo: false).get();

      final batch = _firestore.batch();
      for (final doc in snapshot.docs) {
        batch.update(doc.reference, {'isRead': true});
      }
      await batch.commit();
    } on FirebaseException catch (e) {
      throw ServerException(
        message: e.message ?? 'Could not mark all as read',
        statusCode: null,
      );
    }
  }

  @override
  Future<int> getUnreadCount() async {
    try {
      final collection = await _collection;
      final snapshot =
          await collection.where('isRead', isEqualTo: false).get();
      return snapshot.docs.length;
    } on FirebaseException catch (e) {
      throw ServerException(
        message: e.message ?? 'Could not get unread count',
        statusCode: null,
      );
    }
  }

  @override
  Future<void> saveNotification(NotificationModel notification) async {
    try {
      final collection = await _collection;
      final data = notification.toJson();

      // Convert DateTime to Firestore Timestamp before saving
      data['timestamp'] = Timestamp.fromDate(notification.timestamp);

      await collection.doc(notification.id).set(data);
    } on FirebaseException catch (e) {
      throw ServerException(
        message: e.message ?? 'Could not save notification',
        statusCode: null,
      );
    }
  }
}