import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../domain/entities/payment_entity.dart';
import '../../domain/entities/payment_status.dart';
import 'receipt_row.dart';

/// Government-style receipt layout.
/// Top to bottom:
/// Status icon → Status text → Amount → Dotted divider
/// → Receipt fields → Dotted divider → QR code
///
/// The most important visual in the app —
/// must look like a real government document.
class ReceiptCard extends StatelessWidget {
  const ReceiptCard({super.key, required this.payment});

  final PaymentEntity payment;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: AppSpacing.screenHorizontal,
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.white,
        borderRadius: AppSpacing.borderRadiusLG,
        border: Border.all(
          color: isDark ? AppColors.borderDark : AppColors.borderLight,
        ),
        boxShadow: isDark
            ? null
            : [
                BoxShadow(
                  color: AppColors.grey200.withValues(alpha: 0.6),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
      ),
      child: Column(
        children: [
          // ── Status section ──────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
            child: Column(
              children: [
                _StatusIcon(status: payment.status),
                AppSpacing.gapMD,
                Text(
                  _statusText(payment.status),
                  style: AppTextStyles.h3.copyWith(
                    color: _statusColor(payment.status),
                  ),
                ),
                AppSpacing.gapSM,
                // Amount — most prominent element on the screen
                Text(
                  payment.formattedAmount,
                  style: AppTextStyles.receiptAmount,
                ),
              ],
            ),
          ),

          _DottedDivider(isDark: isDark),

          // ── Receipt fields ──────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
            child: Column(
              children: [
                ReceiptRow(
                  label: AppStrings.receiptNumber,
                  value: payment.receiptNumber,
                  isMonospace: true,
                ),
                const Divider(height: 1),
                ReceiptRow(
                  label: AppStrings.date,
                  value: payment.formattedDate,
                ),
                const Divider(height: 1),
                ReceiptRow(
                  label: AppStrings.levyType,
                  value: payment.levyType,
                ),
                const Divider(height: 1),
                ReceiptRow(
                  label: AppStrings.description,
                  value: payment.levyName,
                ),
                const Divider(height: 1),
                ReceiptRow(
                  label: AppStrings.taxId,
                  value: payment.taxId,
                  isMonospace: true,
                ),
                const Divider(height: 1),
                ReceiptRow(
                  label: AppStrings.issuedBy,
                  value: payment.issuedBy,
                  valueStyle: AppTextStyles.receiptValue.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),

          _DottedDivider(isDark: isDark),

          // ── QR code ────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                /// QR encodes all receipt fields.
                /// Tax officer scans to verify payment —
                /// no database lookup, no internet required.
                QrImageView(
                  data: _qrData(payment),
                  version: QrVersions.auto,
                  size: 120,
                  backgroundColor: Colors.white,
                  errorCorrectionLevel: QrErrorCorrectLevel.M,
                ),
                AppSpacing.gapSM,
                Text('Scan to verify payment', style: AppTextStyles.caption),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _statusText(PaymentStatus status) => switch (status) {
        PaymentStatus.paid => AppStrings.paymentSuccessful,
        PaymentStatus.pending => AppStrings.paymentPending,
        PaymentStatus.failed => AppStrings.paymentFailed,
      };

  Color _statusColor(PaymentStatus status) => switch (status) {
        PaymentStatus.paid => AppColors.paid,
        PaymentStatus.pending => AppColors.pending,
        PaymentStatus.failed => AppColors.failed,
      };

  String _qrData(PaymentEntity payment) => [
        'Receipt: ${payment.receiptNumber}',
        'Amount: ${payment.formattedAmount}',
        'Date: ${payment.formattedDate}',
        'Levy: ${payment.levyType}',
        'TaxID: ${payment.taxId}',
        'Issued: ${payment.issuedBy}',
      ].join('\n');
}

// ── Status icon ──────────────────────────────────────────────────

class _StatusIcon extends StatelessWidget {
  const _StatusIcon({required this.status});

  final PaymentStatus status;

  @override
  Widget build(BuildContext context) {
    final (icon, color, bgColor) = switch (status) {
      PaymentStatus.paid => (
          Icons.check_rounded,
          AppColors.paid,
          AppColors.paidBackground,
        ),
      PaymentStatus.pending => (
          Icons.access_time_rounded,
          AppColors.pending,
          AppColors.pendingBackground,
        ),
      PaymentStatus.failed => (
          Icons.close_rounded,
          AppColors.failed,
          AppColors.failedBackground,
        ),
    };

    return Container(
      width: 64,
      height: 64,
      decoration: BoxDecoration(color: bgColor, shape: BoxShape.circle),
      child: Icon(icon, color: color, size: 32),
    );
  }
}

// ── Dotted divider ───────────────────────────────────────────────

class _DottedDivider extends StatelessWidget {
  const _DottedDivider({required this.isDark});

  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 1,
      child: CustomPaint(
        painter: _DottedLinePainter(
          color: isDark ? AppColors.borderDark : AppColors.borderLight,
        ),
        child: const SizedBox.expand(),
      ),
    );
  }
}

class _DottedLinePainter extends CustomPainter {
  const _DottedLinePainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1;

    const dashWidth = 6.0;
    const dashSpace = 4.0;
    double startX = 0;

    while (startX < size.width) {
      canvas.drawLine(
        Offset(startX, 0),
        Offset(startX + dashWidth, 0),
        paint,
      );
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(_DottedLinePainter oldDelegate) =>
      oldDelegate.color != color;
}