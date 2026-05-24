import 'package:equatable/equatable.dart';

/// A single FCM notification stored in Firestore.
/// Written when notification is received from Firebase.
/// Updated when citizen taps it — isRead becomes true.
///
/// Firestore collection path: notifications/{supabaseUserId}/messages/{docId}
/// supabaseUserId is the Supabase UUID String — acceptable as Firestore path.
class NotificationEntity extends Equatable {
  const NotificationEntity({
    required this.id,
    required this.title,
    required this.body,
    required this.timestamp,
    required this.isRead,
    this.route,
  });

  /// Firestore document id.
  final String id;

  final String title;
  final String body;
  final DateTime timestamp;

  /// False when first received — true after citizen taps it.
  final bool isRead;

  /// Optional route for deep link navigation on tap.
  final String? route;

  @override
  List<Object?> get props => [id, title, body, timestamp, isRead];
}