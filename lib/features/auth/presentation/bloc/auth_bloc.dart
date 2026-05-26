
import 'package:etax_revenue_tracker/core/services/notification_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/no_params.dart';
import '../../domain/entities/auth_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';
import '../../domain/usecases/register_usecase.dart';
import 'auth_event.dart';
import 'auth_state.dart';

/// Handles all authentication state.
/// Calls UseCases only — never touches Supabase SDK directly.
@singleton
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(
    this._loginUseCase,
    this._registerUseCase,
    this._logoutUseCase,
    this._authRepository,
     this._notificationService,
  ) : super(const AuthInitialState()) {
    on<LoginEvent>(_onLogin);
    on<RegisterEvent>(_onRegister);
    on<LogoutEvent>(_onLogout);
    on<CheckAuthStatusEvent>(_onCheckAuthStatus);
  }

  final LoginUseCase _loginUseCase;
  final RegisterUseCase _registerUseCase;
  final LogoutUseCase _logoutUseCase;
  final AuthRepository _authRepository;
  final NotificationService _notificationService;

  Future<void> _onLogin(
    LoginEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoadingState());

    final result = await _loginUseCase(
      LoginParams(email: event.email, password: event.password),
    );

    result.fold(
      (failure) => emit(AuthErrorState(message: _mapFailureToMessage(failure))),
      (entity) => emit(AuthenticatedState(entity: entity)),
    );
  }

  Future<void> _onRegister(
    RegisterEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoadingState());

    final result = await _registerUseCase(
      RegisterParams(email: event.email, password: event.password),
    );

    result.fold(
      (failure) => emit(AuthErrorState(message: _mapFailureToMessage(failure))),
      (entity) => emit(AuthenticatedState(entity: entity)),
    );
  }

 Future<void> _onLogout(
  LogoutEvent event,
  Emitter<AuthState> emit,
) async {
  emit(const AuthLoadingState());

  // Delete FCM token before clearing auth
  await _notificationService.deleteToken();

  final result = await _logoutUseCase(const NoParams());

  result.fold(
    (failure) => emit(AuthErrorState(message: _mapFailureToMessage(failure))),
    (_) => emit(const UnauthenticatedState()),
  );
}

  Future<void> _onCheckAuthStatus(
    CheckAuthStatusEvent event,
    Emitter<AuthState> emit,
  ) async {
    final isLoggedIn = await _authRepository.isLoggedIn();

    if (isLoggedIn) {
      final token = await _authRepository.getAccessToken();
      final userId = await _authRepository.getUserId();
      emit(AuthenticatedState(
        entity: AuthEntity(
          accessToken: token ?? '',
          refreshToken: '',
          userId: userId ?? '',
          email: '',
        ),
      ));
    } else {
      emit(const UnauthenticatedState());
    }
  }

  String _mapFailureToMessage(Failure failure) {
    return switch (failure) {
      NetworkFailure() =>
        'No internet connection. Check your connection and try again.',
      AuthFailure(:final message) => message,
      SessionExpiredFailure() =>
        'Your session has expired. Please sign in again.',
      ServerFailure(:final message) => message,
      _ => 'Something went wrong. Please try again.',
    };
  }
}