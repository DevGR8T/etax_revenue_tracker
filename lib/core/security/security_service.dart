import 'package:etax_revenue_tracker/core/config/flavor_config.dart';
import 'package:injectable/injectable.dart';
import 'package:safe_device/safe_device.dart';

/// Checks device security before sensitive operations.
/// Runs on every app launch and before payment screen entry.

@lazySingleton
class DeviceSecurityService {
  /// Returns true if device is rooted, jailbroken,
  /// or has developer mode enabled.
  Future<bool> isDeviceCompromised() async {
    if (FlavorConfig.isDev) return false; // skip check in dev mode
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
