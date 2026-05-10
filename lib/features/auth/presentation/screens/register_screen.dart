import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/security/input_validator.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import '../widgets/auth_primary_button.dart';
import '../widgets/auth_text_field.dart';
import '../widgets/nigerian_states_dropdown.dart';
import '../widgets/password_strength_bar.dart';
import '../widgets/terms_checkbox.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  bool _termsAccepted = false;
  String? _selectedState;
  String _password = '';

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _onRegister() {
    if (!_termsAccepted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(AppStrings.acceptTerms),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    if (_formKey.currentState?.validate() ?? false) {
      context.read<AuthBloc>().add(
            RegisterEvent(
              email: _emailController.text.trim(),
              password: _passwordController.text,
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthenticatedState) {
          context.go(RouteNames.dashboard);
        }
        if (state is AuthErrorState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppColors.error,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      },
      builder: (context, state) {
        final isLoading = state is AuthLoadingState;

        return Scaffold(
          body: SafeArea(
            child: SingleChildScrollView(
              padding: AppSpacing.screenPadding,
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppSpacing.gapXL,
                    Text(
                      AppStrings.registerTitle,
                      style: AppTextStyles.h1,
                    ),
                    AppSpacing.gapXS,
                    Text(
                      AppStrings.registerSubtitle,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.grey500,
                      ),
                    ),
                    AppSpacing.gapXL,

                    // Full Name
                    AuthTextField(
                      label: AppStrings.fullName,
                      hint: 'Enter your full name',
                      controller: _fullNameController,
                      textInputAction: TextInputAction.next,
                      enabled: !isLoading,
                      validator: InputValidator.fullName,
                    ),
                    AppSpacing.gapMD,

                    // Email
                    AuthTextField(
                      label: AppStrings.email,
                      hint: 'Enter your email address',
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      enabled: !isLoading,
                      validator: InputValidator.email,
                    ),
                    AppSpacing.gapMD,

                    // Phone
                    AuthTextField(
                      label: AppStrings.phoneNumber,
                      hint: '+234 or 080...',
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      textInputAction: TextInputAction.next,
                      enabled: !isLoading,
                      validator: InputValidator.phoneNumber,
                    ),
                    AppSpacing.gapMD,

                    // State dropdown
                    NigerianStatesDropdown(
                      value: _selectedState,
                      enabled: !isLoading,
                      onChanged: (value) {
                        setState(() => _selectedState = value);
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return AppStrings.fieldRequired;
                        }
                        return null;
                      },
                    ),
                    AppSpacing.gapMD,

                    // Password
                    AuthTextField(
                      label: AppStrings.password,
                      hint: 'Min 8 chars, 1 number, 1 uppercase',
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      textInputAction: TextInputAction.next,
                      enabled: !isLoading,
                      validator: InputValidator.password,
                      onChanged: (value) {
                        setState(() => _password = value);
                      },
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                    ),

                    // Password strength bar
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 0,
                        vertical: 4,
                      ),
                      child: PasswordStrengthBar(password: _password),
                    ),
                    AppSpacing.gapSM,

                    // Confirm Password
                    AuthTextField(
                      label: AppStrings.confirmPassword,
                      hint: 'Re-enter your password',
                      controller: _confirmPasswordController,
                      obscureText: _obscureConfirm,
                      textInputAction: TextInputAction.done,
                      enabled: !isLoading,
                      onFieldSubmitted: (_) => _onRegister(),
                      validator: (value) => InputValidator.confirmPassword(
                        value,
                        _passwordController.text,
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureConfirm
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureConfirm = !_obscureConfirm;
                          });
                        },
                      ),
                    ),
                    AppSpacing.gapMD,

                    // Terms checkbox
                    TermsCheckbox(
                      value: _termsAccepted,
                      onChanged: isLoading
                          ? null
                          : (value) {
                              setState(() {
                                _termsAccepted = value ?? false;
                              });
                            },
                    ),
                    AppSpacing.gapLG,

                    // Create Account button
                    AuthPrimaryButton(
                      label: AppStrings.createAccount,
                      onPressed: _termsAccepted ? _onRegister : null,
                      isLoading: isLoading,
                    ),
                    AppSpacing.gapLG,

                    // Login link
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          AppStrings.alreadyHaveAccount,
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.grey500,
                          ),
                        ),
                        GestureDetector(
                          onTap: isLoading
                              ? null
                              : () => context.go(RouteNames.login),
                          child: Text(
                            AppStrings.signIn,
                            style: AppTextStyles.labelLarge.copyWith(
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                    AppSpacing.gapMD,

                    Center(
                      child: Text(
                        AppStrings.appTagline,
                        style: AppTextStyles.caption,
                      ),
                    ),
                    AppSpacing.gapMD,
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}