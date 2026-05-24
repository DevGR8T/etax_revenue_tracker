import 'package:equatable/equatable.dart';

abstract class PayTaxEvent extends Equatable {
  const PayTaxEvent();

  @override
  List<Object?> get props => [];
}

/// Fired when citizen taps Make Payment.
/// All fields validated before this event fires.
class SubmitPaymentEvent extends PayTaxEvent {
  const SubmitPaymentEvent({
    required this.levyType,
    required this.assessmentYear,
    required this.amount,
    required this.referenceNumber,
    this.notes,
  });

  final String levyType;
  final String assessmentYear;
  final double amount;
  final String referenceNumber;
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

/// Fired when citizen taps Pay Another in success dialog.
/// Resets form and state back to idle.
class ResetPayTaxEvent extends PayTaxEvent {
  const ResetPayTaxEvent();
}