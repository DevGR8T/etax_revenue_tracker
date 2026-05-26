import 'package:etax_revenue_tracker/shared/widgets/app_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/route_names.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import '../widgets/login_form.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthenticatedState) {
          context.go(RouteNames.dashboard);
        }
        if (state is AuthErrorState) {
        AppSnackbar.showError(context, state.message);
        }
      },
      builder: (context, state) {
        final isLoading = state is AuthLoadingState;

        return Scaffold(
          body: SafeArea(
            child: LoginForm(
              isLoading: isLoading,
              onLogin: (email, password) {
                context.read<AuthBloc>().add(
                      LoginEvent(email: email, password: password),
                    );
              },
            ),
          ),
        );
      },
    );
  }
}