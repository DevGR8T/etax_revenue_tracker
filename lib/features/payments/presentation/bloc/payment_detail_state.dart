import 'package:equatable/equatable.dart';
import '../../domain/entities/payment_entity.dart';

abstract class PaymentDetailState extends Equatable {
  const PaymentDetailState();

  @override
  List<Object?> get props => [];
}

class PaymentDetailInitialState extends PaymentDetailState {
  const PaymentDetailInitialState();
}

/// Loading — skeleton grey boxes matching receipt layout.
class PaymentDetailLoadingState extends PaymentDetailState {
  const PaymentDetailLoadingState();
}

/// Loaded — full receipt visible.
class PaymentDetailLoadedState extends PaymentDetailState {
  const PaymentDetailLoadedState({required this.payment});

  final PaymentEntity payment;

  @override
  List<Object?> get props => [payment];
}

/// Error — Unable to load receipt + Retry button.
class PaymentDetailErrorState extends PaymentDetailState {
  const PaymentDetailErrorState({
    required this.message,
    required this.id,
  });

  final String message;

  /// Store id so retry can re-fire LoadPaymentDetailEvent
  /// without needing to pass it through the widget tree.
  final int id;

  @override
  List<Object?> get props => [message, id];
}