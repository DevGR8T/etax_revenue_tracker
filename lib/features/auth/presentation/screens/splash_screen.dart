import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/security/security_service.dart';
import '../../../../core/di/injection.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';

/// App entry point.
/// Runs security check then auth check.
/// Routes to correct screen — citizen never manually navigates.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );
    _controller.forward();
    _initialize();
  }

  Future<void> _initialize() async {
    // Minimum splash display time
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    // Security check first — before anything else
    final securityService = getIt<DeviceSecurityService>();
    final isCompromised = await securityService.isDeviceCompromised();

    if (isCompromised && mounted) {
      _showSecurityWarning();
      return;
    }

    // Fire auth check
    if (mounted) {
      context.read<AuthBloc>().add(const CheckAuthStatusEvent());
    }
  }

  void _showSecurityWarning() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: const Text('Security Warning'),
        content: const Text(AppStrings.deviceCompromised),
        actions: [
          TextButton(
            onPressed: () {},
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthenticatedState) {
          context.go(RouteNames.dashboard);
        } else if (state is UnauthenticatedState) {
          context.go(RouteNames.login);
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.primary,
        body: FadeTransition(
          opacity: _fadeAnimation,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo placeholder — replace with real asset
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: AppColors.white.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(
                    Icons.account_balance,
                    size: 44,
                    color: AppColors.white,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  AppStrings.appName,
                  style: AppTextStyles.h1.copyWith(
                    color: AppColors.white,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  AppStrings.appTagline,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.white.withValues(alpha: 0.7),
                  ),
                ),
                const SizedBox(height: 80),
                SizedBox(
                  width: 200,
                  child: LinearProgressIndicator(
                    backgroundColor: AppColors.white.withValues(alpha: 0.2),
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      AppColors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}