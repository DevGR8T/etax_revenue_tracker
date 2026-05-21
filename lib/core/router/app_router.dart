import 'dart:async';

import 'package:etax_revenue_tracker/features/dashboard/presentation/screens/dashboard_screen.dart';
import 'package:etax_revenue_tracker/features/payments/presentation/screens/payment_history_screen.dart';
import 'package:etax_revenue_tracker/shared/widgets/main_shell.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/auth/presentation/bloc/auth_state.dart';
import '../../features/auth/presentation/screens/splash_screen.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/register_screen.dart';
import '../../features/auth/presentation/screens/forgot_password_screen.dart';
import '../../features/auth/presentation/screens/set_password_screen.dart';
import '../di/injection.dart';
import 'route_names.dart';

/// Auth guard — runs before every navigation event.
/// Token check is async — splash handles the initial redirect.
String? _authGuard(BuildContext context, GoRouterState state) {
  final authState = context.read<AuthBloc>().state;

  final isAuthRoute =
      state.matchedLocation == RouteNames.login ||
      state.matchedLocation == RouteNames.register ||
      state.matchedLocation == RouteNames.forgotPassword ||
      state.matchedLocation == RouteNames.setPassword ||
      state.matchedLocation == RouteNames.splash;

  final isProtectedRoute =
      state.matchedLocation == RouteNames.dashboard ||
      state.matchedLocation == RouteNames.history ||
      state.matchedLocation == RouteNames.profile ||
      state.matchedLocation == RouteNames.payTax ||
      state.matchedLocation.startsWith('/history/');

  if (authState is AuthenticatedState &&
      isAuthRoute &&
      state.matchedLocation != RouteNames.splash) {
    return RouteNames.dashboard;
  }

  if (authState is UnauthenticatedState && isProtectedRoute) {
    return RouteNames.login;
  }

  return null;
}

final GoRouter appRouter = GoRouter(
  initialLocation: RouteNames.splash,
  debugLogDiagnostics: true,
  redirect: _authGuard,
  refreshListenable: GoRouterRefreshStream(getIt<AuthBloc>().stream),
  routes: [
    GoRoute(
  path: RouteNames.splash,
  builder: (context, _) => const SplashScreen(),
),
GoRoute(
  path: RouteNames.login,
  builder: (context, _) => const LoginScreen(),
),
GoRoute(
  path: RouteNames.register,
  builder: (context, _) => const RegisterScreen(),
),
GoRoute(
  path: RouteNames.forgotPassword,
  builder: (context, _) => const ForgotPasswordScreen(),
),
GoRoute(
  path: RouteNames.setPassword,
  builder: (context, _) => const SetPasswordScreen(),
),
GoRoute(
  path: RouteNames.payTax,
  builder: (context, _) => const _PlaceholderScreen(label: 'Pay Tax'),
),
ShellRoute(
  builder: (context, _, child) => MainShell(child: child),
  routes: [
    GoRoute(
      path: RouteNames.dashboard,
      builder: (context, _) => const DashboardScreen(),
    ),
    GoRoute(
      path: RouteNames.history,
      builder: (context, _) =>
          const PaymentHistoryScreen(),
    ),
    GoRoute(
      path: RouteNames.profile,
      builder: (context, _) =>
          const _PlaceholderScreen(label: 'Profile'),
    ),
  ],
),
  ],
);

/// Listens to BLoC stream and refreshes router on state change.
class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.listen((_) => notifyListeners());
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

class _PlaceholderScreen extends StatelessWidget {
  const _PlaceholderScreen({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(label)),
      body: Center(
        child: Text(label, style: Theme.of(context).textTheme.headlineMedium),
      ),
    );
  }
}


