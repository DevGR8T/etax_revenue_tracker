import 'package:etax_revenue_tracker/shared/widgets/app_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/security/input_validator.dart';
import '../../../../features/auth/presentation/widgets/auth_text_field.dart';
import '../bloc/pay_tax_bloc.dart';
import '../bloc/pay_tax_event.dart';
import '../bloc/pay_tax_state.dart';
import '../widgets/assessment_year_dropdown.dart';
import '../widgets/levy_type_dropdown.dart';
import '../widgets/payment_success_dialog.dart';

class PayTaxScreen extends StatelessWidget {
  const PayTaxScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<PayTaxBloc>(),
      child: const _PayTaxView(),
    );
  }
}

class _PayTaxView extends StatefulWidget {
  const _PayTaxView();

  @override
  State<_PayTaxView> createState() => _PayTaxViewState();
}

class _PayTaxViewState extends State<_PayTaxView> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _notesController = TextEditingController();

  /// Auto-generated once in initState — never editable by citizen.
  /// Re-generated only when Pay Another is tapped.
  late String _referenceNumber;

  String? _selectedLevyType;
  String? _selectedYear;

  /// Prevents success dialog from showing more than once
  /// even if widget rebuilds while in PayTaxSuccessState.
  bool _dialogShown = false;

  @override
  void initState() {
    super.initState();
    _referenceNumber = _generateReference();
  }

  @override
  void dispose() {
    _amountController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  String _generateReference() =>
      const Uuid().v4().substring(0, 16).toUpperCase();

  void _onSubmit() {
    if (_formKey.currentState?.validate() ?? false) {
      final amount = double.tryParse(
        _amountController.text.trim().replaceAll(',', ''),
      );
      if (amount == null) return;

      context.read<PayTaxBloc>().add(
        SubmitPaymentEvent(
          levyType: _selectedLevyType!,
          assessmentYear: _selectedYear!,
          amount: amount,
          referenceNumber: _referenceNumber,
          notes: _notesController.text.trim().isEmpty
              ? null
              : _notesController.text.trim(),
        ),
      );
    }
  }

  void _clearForm() {
    _amountController.clear();
    _notesController.clear();
    setState(() {
      _selectedLevyType = null;
      _selectedYear = null;
      _dialogShown = false;
      // Generate new reference for the next payment
      _referenceNumber = _generateReference();
    });
    context.read<PayTaxBloc>().add(const ResetPayTaxEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PayTaxBloc, PayTaxState>(
      listener: (context, state) {
        if (state is PayTaxErrorState) {
         AppSnackbar.showError(context, state.message);
        }

        // Show success dialog exactly once
        if (state is PayTaxSuccessState && !_dialogShown) {
          _dialogShown = true;
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) => PaymentSuccessDialog(
              payment: state.payment,
              onViewReceipt: () {
                Navigator.of(context).pop();
                context
                    .push(RouteNames.paymentReceipt, extra: state.payment)
                    .then((_) {
                      // User came back from receipt — reset form
                      _clearForm();
                    });
              },
              onPayAnother: () {
                Navigator.of(context).pop();
                _clearForm();
              },
            ),
          );
        }
      },
      builder: (context, state) {
        final isLoading = state is PayTaxLoadingState;

        return Scaffold(
          appBar: AppBar(
            title: Text(AppStrings.payTax, style: AppTextStyles.h4),
          ),
          body: SingleChildScrollView(
            padding: AppSpacing.screenPadding,
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppStrings.payTaxSubtitle,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.grey500,
                    ),
                  ),
                  AppSpacing.gapXL,

                  // Levy Type
                  LevyTypeDropdown(
                    value: _selectedLevyType,
                    enabled: !isLoading,
                    onChanged: (value) =>
                        setState(() => _selectedLevyType = value),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select a levy type';
                      }
                      return null;
                    },
                  ),
                  AppSpacing.gapMD,

                  // Assessment Year
                  AssessmentYearDropdown(
                    value: _selectedYear,
                    enabled: !isLoading,
                    onChanged: (value) => setState(() => _selectedYear = value),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select an assessment year';
                      }
                      return null;
                    },
                  ),
                  AppSpacing.gapMD,

                  // Amount
                  _AmountField(
                    controller: _amountController,
                    enabled: !isLoading,
                  ),
                  AppSpacing.gapMD,

                  // Reference Number — read only, auto-generated
                  AuthTextField(
                    label: AppStrings.referenceNumber,
                    hint: _referenceNumber,
                    initialValue: _referenceNumber,
                    enabled: false,
                    readOnly: true,
                  ),
                  AppSpacing.gapMD,

                  // Notes — optional
                  AuthTextField(
                    label: AppStrings.notes,
                    hint: 'Add a note (optional)',
                    controller: _notesController,
                    enabled: !isLoading,
                    maxLines: 3,
                    textInputAction: TextInputAction.newline,
                  ),
                  AppSpacing.gapXL,

                  // Make Payment button
                  _SubmitButton(isLoading: isLoading, onPressed: _onSubmit),
                  AppSpacing.gapXL,
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

// ── Amount field ─────────────────────────────────────────────────

class _AmountField extends StatelessWidget {
  const _AmountField({required this.controller, required this.enabled});

  final TextEditingController controller;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.amount,
          style: AppTextStyles.labelLarge.copyWith(
            color: isDark
                ? AppColors.textPrimaryDark
                : AppColors.textPrimaryLight,
          ),
        ),
        AppSpacing.gapXS,
        TextFormField(
          controller: controller,
          enabled: enabled,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          textInputAction: TextInputAction.next,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          // Prevents letters, multiple decimal points, >2 decimal places
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
          ],
          validator: InputValidator.amount,
          decoration: InputDecoration(
            hintText: '0.00',
            prefixIcon: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Text(
                '₦',
                style: AppTextStyles.h4.copyWith(color: AppColors.primary),
              ),
            ),
            prefixIconConstraints: const BoxConstraints(
              minWidth: 0,
              minHeight: 0,
            ),
          ),
        ),
      ],
    );
  }
}

// ── Submit button ────────────────────────────────────────────────

class _SubmitButton extends StatelessWidget {
  const _SubmitButton({required this.isLoading, required this.onPressed});

  final bool isLoading;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        child: isLoading
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.white),
                ),
              )
            : Text(AppStrings.makePayment, style: AppTextStyles.button),
      ),
    );
  }
}
