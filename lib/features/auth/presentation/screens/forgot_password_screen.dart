import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/security/input_validator.dart';
import '../bloc/forgot_password_cubit.dart';
import '../widgets/auth_primary_button.dart';
import '../widgets/auth_text_field.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _onSendResetLink() {
    if (_formKey.currentState?.validate() ?? false) {
      context
          .read<ForgotPasswordCubit>()
          .sendResetLink(_emailController.text.trim());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: () => context.go(RouteNames.login),
        ),
      ),
      body: BlocBuilder<ForgotPasswordCubit, ForgotPasswordState>(
        builder: (context, state) {
          final isLoading = state is ForgotPasswordLoadingState;
          final isSuccess = state is ForgotPasswordSuccessState;

          return SafeArea(
            child: SingleChildScrollView(
              padding: AppSpacing.screenPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppSpacing.gapXL,
                  Text(AppStrings.forgotPasswordTitle, style: AppTextStyles.h1),
                  AppSpacing.gapXS,
                  Text(
                    AppStrings.forgotPasswordSubtitle,
                    style: AppTextStyles.bodyMedium
                        .copyWith(color: AppColors.grey500),
                  ),
                  AppSpacing.gapXL,

                  if (!isSuccess) ...[
                    Form(
                      key: _formKey,
                      child: AuthTextField(
                        label: AppStrings.email,
                        hint: 'Enter your registered email',
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.done,
                        enabled: !isLoading,
                        onFieldSubmitted: (_) => _onSendResetLink(),
                        validator: InputValidator.email,
                      ),
                    ),
                    AppSpacing.gapXL,
                    AuthPrimaryButton(
                      label: AppStrings.sendResetLink,
                      onPressed: _onSendResetLink,
                      isLoading: isLoading,
                    ),
                  ],

                  if (isSuccess) ...[
                    Center(
                      child: Column(
                        children: [
                          AppSpacing.gapXL,
                          Container(
                            width: 72,
                            height: 72,
                            decoration: const BoxDecoration(
                              color: AppColors.paidBackground,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.check_rounded,
                              color: AppColors.paid,
                              size: 40,
                            ),
                          ),
                          AppSpacing.gapLG,
                          Text(
                            AppStrings.checkYourEmail,
                            style: AppTextStyles.h3,
                            textAlign: TextAlign.center,
                          ),
                          AppSpacing.gapSM,
                          Text(
                            AppStrings.resetLinkSent,
                            style: AppTextStyles.bodyMedium
                                .copyWith(color: AppColors.grey500),
                            textAlign: TextAlign.center,
                          ),
                          AppSpacing.gapXL,
                          AuthPrimaryButton(
                            label: AppStrings.backToLogin,
                            onPressed: () => context.go(RouteNames.login),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}