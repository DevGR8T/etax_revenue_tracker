import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/security/input_validator.dart';
import 'auth_primary_button.dart';
import 'auth_text_field.dart';
import 'package:go_router/go_router.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({
    super.key,
    required this.isLoading,
    required this.onLogin,
  });

  final bool isLoading;
  final void Function(String email, String password) onLogin;

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      widget.onLogin(
        _emailController.text.trim(),
        _passwordController.text,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: AppSpacing.screenPadding,
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppSpacing.gapXXL,
            Text(AppStrings.signInTitle, style: AppTextStyles.h1),
            AppSpacing.gapXS,
            Text(
              AppStrings.signInSubtitle,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.grey500,
              ),
            ),
            AppSpacing.gapXL,

            // Email
            AuthTextField(
              label: AppStrings.email,
              hint: 'Enter your email',
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              enabled: !widget.isLoading,
              validator: InputValidator.email,
            ),
            AppSpacing.gapMD,

            // Password
            AuthTextField(
              label: AppStrings.password,
              hint: 'Enter your password',
              controller: _passwordController,
              obscureText: _obscurePassword,
              textInputAction: TextInputAction.done,
              enabled: !widget.isLoading,
              onFieldSubmitted: (_) => _submit(),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return AppStrings.fieldRequired;
                }
                return null;
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
            AppSpacing.gapSM,

            // Forgot password
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: widget.isLoading
                    ? null
                    : () => context.push(RouteNames.forgotPassword),
                child: Text(
                  AppStrings.forgotPassword,
                  style: AppTextStyles.labelLarge.copyWith(
                    color: AppColors.primary,
                  ),
                ),
              ),
            ),
            AppSpacing.gapMD,

            // Sign In button
            AuthPrimaryButton(
              label: AppStrings.signIn,
              onPressed: _submit,
              isLoading: widget.isLoading,
            ),
            AppSpacing.gapLG,

            // Register link
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  AppStrings.noAccount,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.grey500,
                  ),
                ),
                GestureDetector(
                  onTap: widget.isLoading
                      ? null
                      : () => context.go(RouteNames.register),
                  child: Text(
                    AppStrings.signUp,
                    style: AppTextStyles.labelLarge.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
            AppSpacing.gapXL,

            // Powered by
            Center(
              child: Text(
                AppStrings.appTagline,
                style: AppTextStyles.caption,
              ),
            ),
          ],
        ),
      ),
    );
  }
}