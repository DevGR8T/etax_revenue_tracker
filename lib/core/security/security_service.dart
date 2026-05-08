import 'package:injectable/injectable.dart';
import 'package:safe_device/safe_device.dart';

/// Checks device security before sensitive operations.
/// Runs on every app launch and before payment screen entry.

@lazySingleton
class DeviceSecurityService {
  /// Returns true if device is rooted, jailbroken,
  /// or has developer mode enabled.
  Future<bool> isDeviceCompromised() async {
    try {
      final isJailbroken = await SafeDevice.isJailBroken;
      final isDeveloperMode = await SafeDevice.isDevelopmentModeEnable;
      return isJailbroken || isDeveloperMode;
    } catch (_) {
      // If detection fails, assume device is safe
      // Do not block citizens due to detection library errors
      return false;
    }
  }
}
