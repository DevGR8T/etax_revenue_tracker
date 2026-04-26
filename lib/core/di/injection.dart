import 'package:get_it/get_it.dart';

final GetIt getIt = GetIt.instance;

/// Registered all dependencies bottom-up:
/// SecureStorage → LocalDB → DataSource → Repository → UseCase → BLoC
///
/// Security services registered first — they are required by
/// the network layer before any API call is made.
Future<void> setupGetIt() async {
  // ── Security (registered first) ──────────────────────────
  // DeviceSecurityService, BiometricService 

  // ── External ──────────────────────────────────────────────
  // Dio, FlutterSecureStorage, AppDatabase 

  // ── Core Services ─────────────────────────────────────────
  // AuthService, ConnectivityService, NotificationService 

  // ── Features ──────────────────────────────────────────────
  // Auth, Dashboard, Payments, Profile added feature by feature
}

