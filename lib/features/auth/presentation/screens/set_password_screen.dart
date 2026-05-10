import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/security/input_validator.dart';
import '../widgets/auth_primary_button.dart';
import '../widgets/auth_text_field.dart';
import '../widgets/password_strength_bar.dart';

class SetPasswordScreen extends StatefulWidget {
  const SetPasswordScreen({super.key});

  @override
  State<SetPasswordScreen> createState() => _SetPasswordScreenState();
}

class _SetPasswordScreenState extends State<SetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  String _password = '';

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  void _onSetPassword() {
    if (_formKey.currentState?.validate() ?? false) {
      // Navigate to login with success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Password updated successfully'),
          backgroundColor: AppColors.paid,
          behavior: SnackBarBehavior.floating,
        ),
      );
      context.go(RouteNames.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Set New Password')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: AppSpacing.screenPadding,
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppSpacing.gapXL,
                Text('Set New Password', style: AppTextStyles.h2),
                AppSpacing.gapXS,
                Text(
                  'Choose a strong password for your account.',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.grey500,
                  ),
                ),
                AppSpacing.gapXL,

                AuthTextField(
                  label: AppStrings.password,
                  hint: 'Min 8 chars, 1 number, 1 uppercase',
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  textInputAction: TextInputAction.next,
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
                    onPressed: () => setState(
                      () => _obscurePassword = !_obscurePassword,
                    ),
                  ),
                ),

                PasswordStrengthBar(password: _password),
                AppSpacing.gapMD,

                AuthTextField(
                  label: AppStrings.confirmPassword,
                  hint: 'Re-enter your password',
                  controller: _confirmController,
                  obscureText: _obscureConfirm,
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (_) => _onSetPassword(),
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
                    onPressed: () => setState(
                      () => _obscureConfirm = !_obscureConfirm,
                    ),
                  ),
                ),
                AppSpacing.gapXL,

                AuthPrimaryButton(
                  label: 'Set Password',
                  onPressed: _onSetPassword,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}