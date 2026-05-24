import 'package:equatable/equatable.dart';
import '../../domain/entities/payment_entity.dart';

abstract class PayTaxState extends Equatable {
  const PayTaxState();

  @override
  List<Object?> get props => [];
}

/// Idle — form enabled, Make Payment button active when valid.
class PayTaxIdleState extends PayTaxState {
  const PayTaxIdleState();
}

/// Loading — all fields disabled, button shows spinner.
class PayTaxLoadingState extends PayTaxState {
  const PayTaxLoadingState();
}

/// Success — AlertDialog appears with receipt number.
class PayTaxSuccessState extends PayTaxState {
  const PayTaxSuccessState({required this.payment});

  final PaymentEntity payment;

  @override
  List<Object?> get props => [payment];
}

/// Error — SnackBar shown.
/// Form re-enabled for citizen to retry.
class PayTaxErrorState extends PayTaxState {
  const PayTaxErrorState({required this.message});

  final String message;

  @override
  List<Object?> get props => [message];
}