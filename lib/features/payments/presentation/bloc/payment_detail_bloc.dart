import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/usecases/get_payment_detail_usecase.dart';
import 'payment_detail_event.dart';
import 'payment_detail_state.dart';

/// Manages receipt screen state.
/// Simple — one event, three possible states.
/// Loading → Loaded or Error.
///
/// Error state now stores the id so the screen
/// can retry without any hacks.
@injectable
class PaymentDetailBloc
    extends Bloc<PaymentDetailEvent, PaymentDetailState> {
  PaymentDetailBloc(this._getPaymentDetailUseCase)
      : super(const PaymentDetailInitialState()) {
    on<LoadPaymentDetailEvent>(_onLoad);
  }

  final GetPaymentDetailUseCase _getPaymentDetailUseCase;

  Future<void> _onLoad(
    LoadPaymentDetailEvent event,
    Emitter<PaymentDetailState> emit,
  ) async {
    emit(const PaymentDetailLoadingState());

    final result = await _getPaymentDetailUseCase(
      GetPaymentDetailParams(id: event.id),
    );

    result.fold(
      (failure) => emit(
        PaymentDetailErrorState(
          message: _mapFailure(failure),
          id: event.id,
        ),
      ),
      (payment) => emit(PaymentDetailLoadedState(payment: payment)),
    );
  }

  String _mapFailure(Failure failure) {
    return switch (failure) {
      NetworkFailure() => 'No internet connection. Check your connection.',
      ServerFailure(:final message) => message,
      _ => 'Unable to load receipt. Please try again.',
    };
  }
}