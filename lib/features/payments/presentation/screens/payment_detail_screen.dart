import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share_plus/share_plus.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/di/injection.dart';
import '../../../../shared/widgets/app_error_widget.dart';
import '../../domain/entities/payment_entity.dart';
import '../bloc/payment_detail_bloc.dart';
import '../bloc/payment_detail_event.dart';
import '../bloc/payment_detail_state.dart';
import '../widgets/receipt_card.dart';
import '../widgets/receipt_skeleton.dart';

class PaymentDetailScreen extends StatelessWidget {
  const PaymentDetailScreen({
    super.key,
    required this.paymentId,
  });

  /// Product id passed from GoRouter path parameter.
  final String paymentId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<PaymentDetailBloc>()
        ..add(
          LoadPaymentDetailEvent(id: int.tryParse(paymentId) ?? 1),
        ),
      child: const _PaymentDetailView(),
    );
  }
}

class _PaymentDetailView extends StatelessWidget {
  const _PaymentDetailView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Receipt', style: AppTextStyles.h4),
        actions: [
          BlocBuilder<PaymentDetailBloc, PaymentDetailState>(
            builder: (context, state) {
              if (state is PaymentDetailLoadedState) {
                return IconButton(
                  icon: const Icon(Icons.share_outlined),
                  tooltip: AppStrings.shareReceipt,
                  onPressed: () => _shareReceipt(state.payment),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
      body: BlocBuilder<PaymentDetailBloc, PaymentDetailState>(
        builder: (context, state) {
          return switch (state) {
            PaymentDetailLoadingState() => const SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: 24),
                    ReceiptSkeleton(),
                    SizedBox(height: 80),
                  ],
                ),
              ),

            PaymentDetailLoadedState(:final payment) =>
              _LoadedBody(payment: payment),

            PaymentDetailErrorState(:final message, :final id) =>
              AppErrorWidget(
                message: message,
                onRetry: () => context
                    .read<PaymentDetailBloc>()
                    .add(LoadPaymentDetailEvent(id: id)),
              ),

            _ => const SizedBox.shrink(),
          };
        },
      ),
    );
  }

  void _shareReceipt(PaymentEntity payment) {
    final text = _buildReceiptText(payment);
    Share.share(text, subject: 'eTax Receipt — ${payment.receiptNumber}');
  }
}

// ── Loaded body ──────────────────────────────────────────────────

class _LoadedBody extends StatelessWidget {
  const _LoadedBody({required this.payment});

  final PaymentEntity payment;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          AppSpacing.gapLG,
          ReceiptCard(payment: payment),
          AppSpacing.gapXL,

          // Share button — full width at bottom
          Padding(
            padding: AppSpacing.screenHorizontal,
            child: SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                onPressed: () => _onShare(),
                icon: const Icon(Icons.share_outlined, size: 18),
                label: Text(
                  AppStrings.shareReceipt,
                  style: AppTextStyles.button,
                ),
              ),
            ),
          ),
          AppSpacing.gapXL,
        ],
      ),
    );
  }

  void _onShare() {
    final text = _buildReceiptText(payment);
    Share.share(text, subject: 'eTax Receipt — ${payment.receiptNumber}');
  }
}

// ── Shared helper ────────────────────────────────────────────────

String _buildReceiptText(PaymentEntity payment) => '''
eTax Revenue Tracker — Payment Receipt

Receipt No: ${payment.receiptNumber}
Amount: ${payment.formattedAmount}
Date: ${payment.formattedDate}
Levy Type: ${payment.levyType}
Description: ${payment.levyName}
Tax ID: ${payment.taxId}
Issued by: ${payment.issuedBy}

Status: ${payment.status.label}
''';