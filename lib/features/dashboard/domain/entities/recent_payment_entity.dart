import 'package:equatable/equatable.dart';

/// Represents a single payment row in the recent transactions section.
/// Derived from DummyJSON product data.
class RecentPaymentEntity extends Equatable {
  const RecentPaymentEntity({
    required this.id,
    required this.levyName,
    required this.amount,
    required this.formattedAmount,
    required this.date,
    required this.formattedDate,
    required this.status,
    required this.statusLabel,
    required this.receiptNumber,
  });

  final int id;

  /// Maps from product.title
  final String levyName;

  /// Maps from product.price
  final double amount;

  /// Formatted as ₦4,500.00
  final String formattedAmount;

  final DateTime date;

  /// Formatted as Jan 5, 2024
  final String formattedDate;

  /// Derived: id % 3 == 0 → paid, 1 → pending, 2 → failed
  final PaymentStatus status;

  /// Human readable: Paid, Pending, Failed
  final String statusLabel;

  /// RCP-2024-00001
  final String receiptNumber;

  @override
  List<Object?> get props => [id, levyName, amount, status];
}

enum PaymentStatus { paid, pending, failed }