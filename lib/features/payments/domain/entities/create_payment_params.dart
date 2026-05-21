import 'package:equatable/equatable.dart';

/// Parameters for creating a new tax payment.
/// Passed from PayTaxScreen → PayTaxBloc → CreatePaymentUseCase.
class CreatePaymentParams extends Equatable {
  const CreatePaymentParams({
    required this.levyType,
    required this.assessmentYear,
    required this.amount,
    required this.referenceNumber,
    this.notes,
  });

  final String levyType;
  final String assessmentYear;
  final double amount;

  /// Auto-generated UUID on PayTax screen load.
  final String referenceNumber;

  /// Optional — max 3 lines.
  final String? notes;

  @override
  List<Object?> get props => [
        levyType,
        assessmentYear,
        amount,
        referenceNumber,
        notes,
      ];
}