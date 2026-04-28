import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'route_names.dart';

/// Skeleton router — screens wired in feature by feature.
/// Every FCM notification tap routes through here 
final GoRouter appRouter = GoRouter(
  initialLocation: RouteNames.splash,
  debugLogDiagnostics: true,
  routes: [
    GoRoute(
      path: RouteNames.splash,
      builder: (_, _) => const _PlaceholderScreen(label: 'Splash'),
    ),
    GoRoute(
      path: RouteNames.login,
      builder: (_, _) => const _PlaceholderScreen(label: 'Login'),
    ),
    GoRoute(
      path: RouteNames.register,
      builder: (_, _) =>
          const _PlaceholderScreen(label: 'Register'),
    ),
    GoRoute(
      path: RouteNames.forgotPassword,
      builder: (_, _) =>
          const _PlaceholderScreen(label: 'Forgot Password'),
    ),
    GoRoute(
      path: RouteNames.setPassword,
      builder: (_, _) =>
          const _PlaceholderScreen(label: 'Set Password'),
    ),
    GoRoute(
      path: RouteNames.payTax,
      builder: (_, _) =>
          const _PlaceholderScreen(label: 'Pay Tax'),
    ),
    GoRoute(
      path: RouteNames.paymentDetail,
      builder: (_, state) {
        final id = state.pathParameters['id'] ?? '';
        return _PlaceholderScreen(label: 'Receipt #$id');
      },
    ),
    ShellRoute(
      builder: (_, _, child) => _ShellPlaceholder(child: child),
      routes: [
        GoRoute(
          path: RouteNames.dashboard,
          builder: (_, _) =>
              const _PlaceholderScreen(label: 'Dashboard'),
        ),
        GoRoute(
          path: RouteNames.history,
          builder: (_, _) =>
              const _PlaceholderScreen(label: 'History'),
        ),
        GoRoute(
          path: RouteNames.profile,
          builder: (_, _) =>
              const _PlaceholderScreen(label: 'Profile'),
        ),
      ],
    ),
  ],
);

class _PlaceholderScreen extends StatelessWidget {
  const _PlaceholderScreen({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(label)),
      body: Center(
        child: Text(
          label,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
    );
  }
}

class _ShellPlaceholder extends StatelessWidget {
  const _ShellPlaceholder({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) => child;
}