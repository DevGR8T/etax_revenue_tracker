import 'package:equatable/equatable.dart';
import 'payment_status.dart';

/// Complete payment record — used in History and Receipt screens.
/// Pure Dart — no JSON, no Flutter, no Dio.
/// Every field is derived or mapped from DummyJSON product.
class PaymentEntity extends Equatable {
  const PaymentEntity({
    required this.id,
    required this.levyName,
    required this.levyType,
    required this.description,
    required this.amount,
    required this.formattedAmount,
    required this.date,
    required this.formattedDate,
    required this.status,
    required this.receiptNumber,
    required this.taxId,
    required this.issuedBy,
    this.thumbnailUrl,
  });

  /// Maps from product.id
  final int id;

  /// Maps from product.title
  final String levyName;

  /// Maps from product.category
  final String levyType;

  /// Maps from product.description
  final String description;

  /// Maps from product.price — double confirmed in Postman
  final double amount;

  /// Formatted as ₦4,500.00
  final String formattedAmount;

  final DateTime date;

  /// Formatted as Jan 5, 2024
  final String formattedDate;

  /// Derived: PaymentStatus.fromId(id)
  final PaymentStatus status;

  /// Generated: RCP-2024-00042
  final String receiptNumber;

  /// Generated from Supabase UUID via ReceiptGenerator.tinFromUuid()
  final String taxId;

  /// Always: Enugu State Internal Revenue Service
  final String issuedBy;

  /// Maps from product.thumbnail — nullable confirmed in Postman
  final String? thumbnailUrl;

  @override
  List<Object?> get props => [id, levyName, amount, status, receiptNumber];
}