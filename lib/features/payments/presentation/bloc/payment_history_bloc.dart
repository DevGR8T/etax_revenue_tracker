import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/payment_entity.dart';
import '../../domain/entities/payment_list_params.dart';
import '../../domain/entities/payment_status.dart';
import '../../domain/entities/search_payments_params.dart';
import '../../domain/usecases/get_payments_usecase.dart';
import '../../domain/usecases/search_payments_usecase.dart';
import 'payment_history_event.dart';
import 'payment_history_state.dart';

/// Manages all 6 payment history states.
/// Handles pagination, debounced search, and local filtering.
/// Never touches Dio, Supabase SDK, or HTTP directly.
@injectable
class PaymentHistoryBloc
    extends Bloc<PaymentHistoryEvent, PaymentHistoryState> {
  PaymentHistoryBloc(
    this._getPaymentsUseCase,
    this._searchPaymentsUseCase,
  ) : super(const PaymentHistoryInitialState()) {
    on<LoadPaymentsEvent>(_onLoad);
    on<LoadMorePaymentsEvent>(_onLoadMore);
    on<SearchPaymentsEvent>(
      _onSearch,
      // 500ms debounce — fires only after citizen stops typing
      transformer: (events, mapper) => events
          .debounceTime(const Duration(milliseconds: 500))
          .switchMap(mapper),
    );
    on<ClearSearchEvent>(_onClearSearch);
    on<FilterPaymentsEvent>(_onFilter);
    on<RefreshPaymentsEvent>(_onRefresh);
  }

  final GetPaymentsUseCase _getPaymentsUseCase;
  final SearchPaymentsUseCase _searchPaymentsUseCase;

  static const int _pageSize = 10;

  Future<void> _onLoad(
    LoadPaymentsEvent event,
    Emitter<PaymentHistoryState> emit,
  ) async {
    emit(const PaymentHistoryLoadingState());

    final result = await _getPaymentsUseCase(
      const PaymentListParams(limit: _pageSize, skip: 0),
    );

    result.fold(
      (failure) => emit(
        PaymentHistoryErrorState(message: _mapFailure(failure)),
      ),
      (listResult) {
        if (listResult.payments.isEmpty) {
          emit(const PaymentHistoryEmptySearchState(query: ''));
          return;
        }

        emit(
          PaymentHistoryLoadedState(
            payments: listResult.payments,
            filteredPayments: listResult.payments,
            total: listResult.total,
            currentSkip: _pageSize,
            activeFilter: PaymentFilter.all,
            hasReachedEnd: listResult.hasReachedEnd,
          ),
        );
      },
    );
  }

  Future<void> _onLoadMore(
    LoadMorePaymentsEvent event,
    Emitter<PaymentHistoryState> emit,
  ) async {
    final currentState = state;
    if (currentState is! PaymentHistoryLoadedState) return;
    if (currentState.hasReachedEnd) return;

    emit(
      PaymentHistoryLoadingMoreState(
        payments: currentState.payments,
        filteredPayments: currentState.filteredPayments,
        total: currentState.total,
        currentSkip: currentState.currentSkip,
        activeFilter: currentState.activeFilter,
        currentQuery: currentState.currentQuery,
      ),
    );

    final result = await _getPaymentsUseCase(
      PaymentListParams(limit: _pageSize, skip: currentState.currentSkip),
    );

    result.fold(
      (_) {
        // On load more failure — return to loaded state with existing data
        emit(currentState);
      },
      (listResult) {
        final allPayments = [
          ...currentState.payments,
          ...listResult.payments,
        ];

        final newSkip = currentState.currentSkip + _pageSize;
        final hasReachedEnd = newSkip >= listResult.total;

        if (hasReachedEnd) {
          emit(
            PaymentHistoryEndOfListState(
              payments: allPayments,
              filteredPayments: _applyFilter(
                allPayments,
                currentState.activeFilter,
              ),
              activeFilter: currentState.activeFilter,
              currentQuery: currentState.currentQuery,
            ),
          );
        } else {
          emit(
            PaymentHistoryLoadedState(
              payments: allPayments,
              filteredPayments: _applyFilter(
                allPayments,
                currentState.activeFilter,
              ),
              total: listResult.total,
              currentSkip: newSkip,
              activeFilter: currentState.activeFilter,
              hasReachedEnd: false,
              currentQuery: currentState.currentQuery,
            ),
          );
        }
      },
    );
  }

  Future<void> _onSearch(
    SearchPaymentsEvent event,
    Emitter<PaymentHistoryState> emit,
  ) async {
    if (event.query.trim().isEmpty) {
      add(const ClearSearchEvent());
      return;
    }

    emit(const PaymentHistoryLoadingState());

    final result = await _searchPaymentsUseCase(
      SearchPaymentsParams(
        query: event.query.trim(),
        limit: _pageSize,
        skip: 0,
      ),
    );

    result.fold(
      (failure) => emit(
        PaymentHistoryErrorState(message: _mapFailure(failure)),
      ),
      (listResult) {
        // Empty array on 200 — confirmed in Postman Day 2
        // NOT a 404 — never emit ErrorState for empty search
        if (listResult.payments.isEmpty) {
          emit(PaymentHistoryEmptySearchState(query: event.query));
          return;
        }

        emit(
          PaymentHistoryLoadedState(
            payments: listResult.payments,
            filteredPayments: listResult.payments,
            total: listResult.total,
            currentSkip: _pageSize,
            activeFilter: PaymentFilter.all,
            hasReachedEnd: listResult.hasReachedEnd,
            currentQuery: event.query,
          ),
        );
      },
    );
  }

  Future<void> _onClearSearch(
    ClearSearchEvent event,
    Emitter<PaymentHistoryState> emit,
  ) async {
    add(const LoadPaymentsEvent());
  }

  void _onFilter(
    FilterPaymentsEvent event,
    Emitter<PaymentHistoryState> emit,
  ) {
    final currentState = state;

    if (currentState is PaymentHistoryLoadedState) {
      emit(
        currentState.copyWith(
          filteredPayments: _applyFilter(
            currentState.payments,
            event.filter,
          ),
          activeFilter: event.filter,
        ),
      );
    } else if (currentState is PaymentHistoryEndOfListState) {
      emit(
        PaymentHistoryEndOfListState(
          payments: currentState.payments,
          filteredPayments: _applyFilter(
            currentState.payments,
            event.filter,
          ),
          activeFilter: event.filter,
          currentQuery: currentState.currentQuery,
        ),
      );
    }
  }

  Future<void> _onRefresh(
    RefreshPaymentsEvent event,
    Emitter<PaymentHistoryState> emit,
  ) async {
    add(const LoadPaymentsEvent());
  }

  /// Apply local filter — no API call.
  /// Status was already derived from id % 3 in toEntity().
  List<PaymentEntity> _applyFilter(
    List<PaymentEntity> payments,
    PaymentFilter filter,
  ) {
    return switch (filter) {
      PaymentFilter.all => payments,
      PaymentFilter.paid =>
        payments.where((p) => p.status == PaymentStatus.paid).toList(),
      PaymentFilter.pending =>
        payments.where((p) => p.status == PaymentStatus.pending).toList(),
      PaymentFilter.failed =>
        payments.where((p) => p.status == PaymentStatus.failed).toList(),
    };
  }

  String _mapFailure(Failure failure) {
    return switch (failure) {
      NetworkFailure() =>
        'No internet connection. Check your connection and try again.',
      ServerFailure(:final message) => message,
      _ => 'Something went wrong. Please try again.',
    };
  }
}