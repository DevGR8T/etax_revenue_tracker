import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'injection.config.dart';

final GetIt getIt = GetIt.instance;

@InjectableInit()
Future<void> setupGetIt() async => getIt.init();

/// Manual registrations for third-party packages
/// that injectable cannot auto-discover.
@module
abstract class ExternalModule {
  /// Flutter Secure Storage — encrypted storage for tokens.
  /// AndroidOptions uses encryptedSharedPreferences for extra security.
  @lazySingleton
  FlutterSecureStorage get secureStorage => const FlutterSecureStorage(
        aOptions: AndroidOptions(),
        iOptions: IOSOptions(
          accessibility: KeychainAccessibility.first_unlock_this_device,
        ),
      );

  /// Connectivity — network status checks.
  @lazySingleton
  Connectivity get connectivity => Connectivity();

  /// LocalAuthentication — biometric auth.
  @lazySingleton
  LocalAuthentication get localAuth => LocalAuthentication();


  /// SharedPreferences — for non-sensitive settings only.
  @preResolve
  @lazySingleton
  Future<SharedPreferences> get sharedPreferences =>
      SharedPreferences.getInstance();

  /// Firestore — for notifications.
@lazySingleton
  FirebaseFirestore get firestore => FirebaseFirestore.instance;

  /// FCM instance for push notifications.
  @lazySingleton
  FirebaseMessaging get firebaseMessaging => FirebaseMessaging.instance;

  /// Local notifications for foreground FCM display.
  @lazySingleton
  FlutterLocalNotificationsPlugin get localNotifications =>
      FlutterLocalNotificationsPlugin();
}