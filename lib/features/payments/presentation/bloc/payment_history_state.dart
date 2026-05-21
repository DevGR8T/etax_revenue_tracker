import 'package:equatable/equatable.dart';
import '../../domain/entities/payment_entity.dart';
import 'payment_history_event.dart';

abstract class PaymentHistoryState extends Equatable {
  const PaymentHistoryState();

  @override
  List<Object?> get props => [];
}

class PaymentHistoryInitialState extends PaymentHistoryState {
  const PaymentHistoryInitialState();
}

/// Loading first page — 6 shimmer rows showing.
class PaymentHistoryLoadingState extends PaymentHistoryState {
  const PaymentHistoryLoadingState();
}

/// Loaded — payment rows visible.
class PaymentHistoryLoadedState extends PaymentHistoryState {
  const PaymentHistoryLoadedState({
    required this.payments,
    required this.filteredPayments,
    required this.total,
    required this.currentSkip,
    required this.activeFilter,
    required this.hasReachedEnd,
    this.currentQuery = '',
  });

  /// Full unfiltered list from API.
  final List<PaymentEntity> payments;

  /// Filtered list shown in UI.
  final List<PaymentEntity> filteredPayments;

  final int total;
  final int currentSkip;
  final PaymentFilter activeFilter;
  final bool hasReachedEnd;
  final String currentQuery;

  PaymentHistoryLoadedState copyWith({
    List<PaymentEntity>? payments,
    List<PaymentEntity>? filteredPayments,
    int? total,
    int? currentSkip,
    PaymentFilter? activeFilter,
    bool? hasReachedEnd,
    String? currentQuery,
  }) {
    return PaymentHistoryLoadedState(
      payments: payments ?? this.payments,
      filteredPayments: filteredPayments ?? this.filteredPayments,
      total: total ?? this.total,
      currentSkip: currentSkip ?? this.currentSkip,
      activeFilter: activeFilter ?? this.activeFilter,
      hasReachedEnd: hasReachedEnd ?? this.hasReachedEnd,
      currentQuery: currentQuery ?? this.currentQuery,
    );
  }

  @override
  List<Object?> get props => [
        payments,
        filteredPayments,
        total,
        currentSkip,
        activeFilter,
        hasReachedEnd,
        currentQuery,
      ];
}

/// Loading more — spinner at bottom only.
/// Existing rows stay visible.
class PaymentHistoryLoadingMoreState extends PaymentHistoryState {
  const PaymentHistoryLoadingMoreState({
    required this.payments,
    required this.filteredPayments,
    required this.total,
    required this.currentSkip,
    required this.activeFilter,
    required this.currentQuery,
  });

  final List<PaymentEntity> payments;
  final List<PaymentEntity> filteredPayments;
  final int total;
  final int currentSkip;
  final PaymentFilter activeFilter;
  final String currentQuery;

  @override
  List<Object?> get props => [
        payments,
        filteredPayments,
        total,
        currentSkip,
        activeFilter,
        currentQuery,
      ];
}

/// All pages loaded.
class PaymentHistoryEndOfListState extends PaymentHistoryState {
  const PaymentHistoryEndOfListState({
    required this.payments,
    required this.filteredPayments,
    required this.activeFilter,
    required this.currentQuery,
  });

  final List<PaymentEntity> payments;
  final List<PaymentEntity> filteredPayments;
  final PaymentFilter activeFilter;
  final String currentQuery;

  @override
  List<Object?> get props => [
        payments,
        filteredPayments,
        activeFilter,
        currentQuery,
      ];
}

/// Search returned no results.
/// Confirmed in Postman Day 2 — empty array on 200, NOT 404.
class PaymentHistoryEmptySearchState extends PaymentHistoryState {
  const PaymentHistoryEmptySearchState({required this.query});

  final String query;

  @override
  List<Object?> get props => [query];
}

/// Error — message + retry button.
class PaymentHistoryErrorState extends PaymentHistoryState {
  const PaymentHistoryErrorState({required this.message});

  final String message;

  @override
  List<Object?> get props => [message];
}