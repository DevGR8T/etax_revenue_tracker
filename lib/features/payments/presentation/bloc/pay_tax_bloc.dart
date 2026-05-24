import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/create_payment_params.dart';
import '../../domain/usecases/create_payment_usecase.dart';
import 'pay_tax_event.dart';
import 'pay_tax_state.dart';

/// Manages Pay Tax form state.
/// Four states: Idle → Loading → Success or Error.
/// Never touches form validation — that lives in the UI.
/// Never touches Supabase SDK or HTTP directly.
@injectable
class PayTaxBloc extends Bloc<PayTaxEvent, PayTaxState> {
  PayTaxBloc(this._createPaymentUseCase) : super(const PayTaxIdleState()) {
    on<SubmitPaymentEvent>(_onSubmit);
    on<ResetPayTaxEvent>(_onReset);
  }

  final CreatePaymentUseCase _createPaymentUseCase;

  Future<void> _onSubmit(
    SubmitPaymentEvent event,
    Emitter<PayTaxState> emit,
  ) async {
    emit(const PayTaxLoadingState());

    final result = await _createPaymentUseCase(
      CreatePaymentParams(
        levyType: event.levyType,
        assessmentYear: event.assessmentYear,
        amount: event.amount,
        referenceNumber: event.referenceNumber,
        notes: event.notes,
      ),
    );

    result.fold(
      (failure) => emit(PayTaxErrorState(message: _mapFailure(failure))),
      (payment) => emit(PayTaxSuccessState(payment: payment)),
    );
  }

  void _onReset(
    ResetPayTaxEvent event,
    Emitter<PayTaxState> emit,
  ) {
    emit(const PayTaxIdleState());
  }

  String _mapFailure(Failure failure) {
    return switch (failure) {
      NetworkFailure() =>
        'No internet connection. Check your connection and try again.',
      _ => AppStrings.paymentError,
    };
  }
}