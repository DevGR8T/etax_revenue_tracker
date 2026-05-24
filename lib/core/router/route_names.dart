/// All named routes in the app.
abstract final class RouteNames {
  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';
  static const String setPassword = '/set-password';
  static const String dashboard = '/dashboard';
  static const String history = '/history';
  static const String paymentDetail = '/history/:id';
  static const String payTax = '/pay';
  static const String paymentReceipt = '/payment-receipt';
  static const String profile = '/profile';

  static String paymentDetailPath(String id) => '/history/$id';
}