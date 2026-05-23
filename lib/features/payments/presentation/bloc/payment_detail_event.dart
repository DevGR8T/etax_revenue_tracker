import 'package:equatable/equatable.dart';

abstract class PaymentDetailEvent extends Equatable {
  const PaymentDetailEvent();

  @override
  List<Object?> get props => [];
}

/// Fired on screen creation with product id from route.
class LoadPaymentDetailEvent extends PaymentDetailEvent {
  const LoadPaymentDetailEvent({required this.id});

  final int id;

  @override
  List<Object?> get props => [id];
}