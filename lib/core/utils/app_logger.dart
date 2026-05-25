import '../config/flavor_config.dart';

/// Centralized logging utility.
/// Only logs in dev mode — never in production.
/// Replaces all print() statements across the app.
/// Sentry handles production error tracking.
abstract final class AppLogger {
  static void debug(String message, {String? tag}) {
    if (FlavorConfig.isDev) {
      final prefix = tag != null ? '[$tag]' : '[DEBUG]';
      // ignore: avoid_print
      print('$prefix $message');
    }
  }

  static void error(String message, {Object? error, String? tag}) {
    if (FlavorConfig.isDev) {
      final prefix = tag != null ? '[$tag ERROR]' : '[ERROR]';
      // ignore: avoid_print
      print('$prefix $message');
      if (error != null) {
        // ignore: avoid_print
        print('  Error: $error');
      }
    }
  }

  static void network(String method, String url, {int? statusCode}) {
    if (FlavorConfig.isDev) {
      final status = statusCode != null ? ' [$statusCode]' : '';
      // ignore: avoid_print
      print('[NETWORK] $method $url$status');
    }
  }
}