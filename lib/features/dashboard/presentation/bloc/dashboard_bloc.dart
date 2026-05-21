import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/no_params.dart';
import '../../domain/usecases/get_dashboard_data_usecase.dart';
import '../../domain/usecases/refresh_dashboard_usecase.dart';
import 'dashboard_event.dart';
import 'dashboard_state.dart';

/// Manages dashboard state.
/// Calls GetDashboardDataUseCase and RefreshDashboardUseCase.
/// Never touches Dio, Supabase SDK, or API directly.
@injectable
class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  DashboardBloc(
    this._getDashboardDataUseCase,
    this._refreshDashboardUseCase,
  ) : super(const DashboardInitialState()) {
    on<LoadDashboardEvent>(_onLoad);
    on<RefreshDashboardEvent>(_onRefresh);
  }

  final GetDashboardDataUseCase _getDashboardDataUseCase;
  final RefreshDashboardUseCase _refreshDashboardUseCase;

  Future<void> _onLoad(
    LoadDashboardEvent event,
    Emitter<DashboardState> emit,
  ) async {
    emit(const DashboardLoadingState());

    final result = await _getDashboardDataUseCase(const NoParams());

    result.fold(
      (failure) => emit(DashboardErrorState(message: _mapFailure(failure))),
      (entity) => emit(DashboardLoadedState(entity: entity)),
    );
  }

  Future<void> _onRefresh(
    RefreshDashboardEvent event,
    Emitter<DashboardState> emit,
  ) async {
    final currentState = state;
    if (currentState is DashboardLoadedState) {
      emit(DashboardRefreshingState(entity: currentState.entity));
    }

    final result = await _refreshDashboardUseCase(const NoParams());

    result.fold(
      (failure) {
        // On refresh failure keep existing data visible
        if (currentState is DashboardLoadedState) {
          emit(DashboardLoadedState(entity: currentState.entity));
        } else {
          emit(DashboardErrorState(message: _mapFailure(failure)));
        }
      },
      (entity) => emit(DashboardLoadedState(entity: entity)),
    );
  }

  String _mapFailure(Failure failure) {
    return switch (failure) {
      NetworkFailure() => 'No internet connection. Please check and try again.',
      ServerFailure(:final message) => message,
      _ => 'Something went wrong. Please try again.',
    };
  }
}