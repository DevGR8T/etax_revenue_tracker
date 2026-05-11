import 'package:equatable/equatable.dart';
import 'package:etax_revenue_tracker/features/dashboard/domain/entities/recent_payment_entity.dart';

/// Pure Dart — no JSON, no Flutter, no Dio.
/// Contains citizen stats and recent payment list.
class DashboardEntity extends Equatable {
  const DashboardEntity({
    required this.citizenName,
    required this.tin,
    required this.totalPaid,
    required this.outstanding,
    required this.receiptCount,
    required this.recentPayments,
  });

  /// Citizen full name — used for greeting header.
  final String citizenName;

  /// Tax Identification Number — generated from user id.
  /// Format: NG-XXXXXXXX
  final String tin;

  /// Sum of all paid payment amounts formatted as double.
  final double totalPaid;

  /// Calculated outstanding amount.
  final double outstanding;

  /// Total number of payment receipts.
  final int receiptCount;

  /// Last 5 payments for the recent transactions section.
  final List<RecentPaymentEntity> recentPayments;

  @override
  List<Object?> get props => [
        citizenName,
        tin,
        totalPaid,
        outstanding,
        receiptCount,
        recentPayments,
      ];
}