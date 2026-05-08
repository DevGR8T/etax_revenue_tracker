import 'package:injectable/injectable.dart';
import 'package:local_auth/local_auth.dart';

/// Wraps local_auth into a clean service.
/// The BLoC calls this service — never local_auth directly.
/// Handles all edge cases: not available, not enrolled, cancelled.
@lazySingleton
class BiometricService {
  BiometricService(this._localAuth);

  final LocalAuthentication _localAuth;

  /// Check if device supports biometric authentication.
  Future<bool> isAvailable() async {
    try {
      return await _localAuth.canCheckBiometrics;
    } catch (_) {
      return false;
    }
  }

  /// Check which biometrics are enrolled.
  Future<List<BiometricType>> getAvailableBiometrics() async {
    try {
      return await _localAuth.getAvailableBiometrics();
    } catch (_) {
      return [];
    }
  }

  /// Prompt the citizen to authenticate with biometrics.
  /// Returns true if authenticated, false if failed or cancelled.
Future<bool> authenticate() async {
    try {
      return await _localAuth.authenticate(
        localizedReason: 'Authenticate to access your eTax account',
        options: const AuthenticationOptions(
          biometricOnly: false,
          stickyAuth: true,
        ),
      );
    } catch (_) {
      return false;
    }
  }
}