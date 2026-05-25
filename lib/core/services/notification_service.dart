import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:injectable/injectable.dart';
import '../services/auth_service.dart';

/// Handles all FCM setup and notification routing.
/// Called once in main.dart before runApp.
///
/// Three scenarios handled:
/// 1. App open (foreground) — show in-app banner
/// 2. App in background — system tray notification
/// 3. App closed — system tray, opens to notifications tab on tap
@lazySingleton
class NotificationService {
  NotificationService(
    this._messaging,
    this._localNotifications,
    this._firestore,
    this._authService,
  );

  final FirebaseMessaging _messaging;
  final FlutterLocalNotificationsPlugin _localNotifications;
  final FirebaseFirestore _firestore;
  final AuthService _authService;

  /// High importance channel id — matches AndroidManifest.xml
  static const String _channelId = 'high_importance_channel';
  static const String _channelName = 'eTax Notifications';

  Future<void> initialize() async {
    // Request permission — iOS requires this, Android 13+
    await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    // Setup Android notification channel
    await _setupAndroidChannel();

    // Setup local notifications for foreground display
    await _setupLocalNotifications();

    // Get and register FCM token
    final token = await _messaging.getToken();
    if (token != null) await _registerToken(token);

    // Refresh token when it changes
    _messaging.onTokenRefresh.listen(_registerToken);

    // Handle foreground messages
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

    // Handle background tap — app was backgrounded
    FirebaseMessaging.onMessageOpenedApp.listen(
      _handleNotificationTap,
    );

    // Handle terminated tap — app was closed
    final initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      _handleNotificationTap(initialMessage);
    }
  }

  /// Register FCM token in Firestore for this citizen.
  /// Used by backend to send targeted notifications.
  Future<void> _registerToken(String token) async {
    try {
      final userId = await _authService.getUserId();
      if (userId == null) return;

      await _firestore
          .collection('fcm_tokens')
          .doc(userId)
          .set({
        'token': token,
        'updatedAt': FieldValue.serverTimestamp(),
        'platform': 'android',
      });
    } catch (_) {
      // Silently fail — token will refresh and retry
    }
  }

  /// Delete FCM token on logout.
  /// Citizen must not receive notifications after logout.
  Future<void> deleteToken() async {
    try {
      await _messaging.deleteToken();
      final userId = await _authService.getUserId();
      if (userId == null) return;
      await _firestore.collection('fcm_tokens').doc(userId).delete();
    } catch (_) {
      // Silently fail
    }
  }

  /// Show in-app banner for foreground notifications.
  /// Also saves to Firestore for the notifications tab.
  Future<void> _handleForegroundMessage(RemoteMessage message) async {
    // Show local notification banner
    await _showLocalNotification(message);

    // Save to Firestore — appears in notifications tab
    await _saveToFirestore(message);
  }

  /// Navigate to notifications tab when notification is tapped.
  /// Routes through GoRouter — auth guard runs, back stack correct.
  void _handleNotificationTap(RemoteMessage message) {
    // Navigation handled via GoRouter on Day 12 screen setup
    // The route from payload will be used here
  }

  Future<void> _showLocalNotification(RemoteMessage message) async {
    final notification = message.notification;
    if (notification == null) return;

    const androidDetails = AndroidNotificationDetails(
      _channelId,
      _channelName,
      importance: Importance.high,
      priority: Priority.high,
      showWhen: true,
    );

    await _localNotifications.show(
  id: notification.hashCode,
  title: notification.title,
  body: notification.body,
  notificationDetails: const NotificationDetails(android: androidDetails),
);
  }

  Future<void> _saveToFirestore(RemoteMessage message) async {
    try {
      final userId = await _authService.getUserId();
      if (userId == null) return;

      await _firestore
          .collection('notifications')
          .doc(userId)
          .collection('messages')
          .add({
        'title': message.notification?.title ?? '',
        'body': message.notification?.body ?? '',
        'timestamp': FieldValue.serverTimestamp(),
        'isRead': false,
        'route': message.data['route'],
      });
    } catch (_) {
      // Silently fail — notification still shows in banner
    }
  }

 Future<void> _setupAndroidChannel() async {
  const channel = AndroidNotificationChannel(
    _channelId,
    _channelName,
    importance: Importance.high,
  );

  await _localNotifications
      .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);
}

  Future<void> _setupLocalNotifications() async {
    const androidInit =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const initSettings =
        InitializationSettings(android: androidInit);

    await _localNotifications.initialize(
      settings: initSettings,
      onDidReceiveNotificationResponse: (details) {
        // Handle tap on local notification
      },
    );
  }
}

/// Top-level handler for background FCM messages.
/// Registered in main.dart.
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(
  RemoteMessage message,
) async {
  // Firebase is already initialized at this point
  // Background messages are handled by the system
}