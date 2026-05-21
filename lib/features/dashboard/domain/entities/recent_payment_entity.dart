import 'package:equatable/equatable.dart';
import '../../../payments/domain/entities/payment_status.dart';

export '../../../payments/domain/entities/payment_status.dart';

/// Represents a single payment row in the recent transactions section.
/// Derived from DummyJSON product data — confirmed in Postman
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
    this.levyType,
    this.description,
  });

  final int id;
  final String levyName;
  final double amount;
  final String formattedAmount;
  final DateTime date;
  final String formattedDate;
  final PaymentStatus status;
  final String statusLabel;
  final String receiptNumber;
  final String? levyType;
  final String? description;

  @override
  List<Object?> get props => [id, levyName, amount, status];
}