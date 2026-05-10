import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/usecases/send_reset_link_usecase.dart';

// ── States ──────────────────────────────────────────────────

abstract class ForgotPasswordState extends Equatable {
  const ForgotPasswordState();

  @override
  List<Object?> get props => [];
}

class ForgotPasswordInitialState extends ForgotPasswordState {
  const ForgotPasswordInitialState();
}

class ForgotPasswordLoadingState extends ForgotPasswordState {
  const ForgotPasswordLoadingState();
}

/// Reset link sent.
/// Always show success — never reveal if email exists.
class ForgotPasswordSuccessState extends ForgotPasswordState {
  const ForgotPasswordSuccessState();
}

class ForgotPasswordErrorState extends ForgotPasswordState {
  const ForgotPasswordErrorState({required this.message});

  final String message;

  @override
  List<Object?> get props => [message];
}

// ── Cubit ───────────────────────────────────────────────────

@injectable
class ForgotPasswordCubit extends Cubit<ForgotPasswordState> {
  ForgotPasswordCubit(this._sendResetLinkUseCase)
      : super(const ForgotPasswordInitialState());

  final SendResetLinkUseCase _sendResetLinkUseCase;

  Future<void> sendResetLink(String email) async {
    emit(const ForgotPasswordLoadingState());

    final result = await _sendResetLinkUseCase(
      SendResetLinkParams(email: email),
    );

    result.fold(
      (failure) => emit(ForgotPasswordErrorState(
        message: failure is NetworkFailure
            ? 'No internet connection.'
            : 'Something went wrong. Please try again.',
      )),
      (_) => emit(const ForgotPasswordSuccessState()),
    );
  }

  void reset() => emit(const ForgotPasswordInitialState());
}