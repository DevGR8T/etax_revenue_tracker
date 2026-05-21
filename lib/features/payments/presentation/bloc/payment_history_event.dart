import 'package:equatable/equatable.dart';

abstract class PaymentHistoryEvent extends Equatable {
  const PaymentHistoryEvent();

  @override
  List<Object?> get props => [];
}

/// Fired on screen creation — loads first page.
class LoadPaymentsEvent extends PaymentHistoryEvent {
  const LoadPaymentsEvent();
}

/// Fired when ScrollController detects 200px from bottom.
class LoadMorePaymentsEvent extends PaymentHistoryEvent {
  const LoadMorePaymentsEvent();
}

/// Fired after 500ms debounce when user stops typing.
///  debounce prevents per-keystroke API calls.
class SearchPaymentsEvent extends PaymentHistoryEvent {
  const SearchPaymentsEvent({required this.query});

  final String query;

  @override
  List<Object?> get props => [query];
}

/// Fired when user taps clear button.
class ClearSearchEvent extends PaymentHistoryEvent {
  const ClearSearchEvent();
}

/// Fired when user taps a filter chip.
/// Applied locally — no new API call.
class FilterPaymentsEvent extends PaymentHistoryEvent {
  const FilterPaymentsEvent({required this.filter});

  final PaymentFilter filter;

  @override
  List<Object?> get props => [filter];
}

/// Fired on pull-to-refresh.
class RefreshPaymentsEvent extends PaymentHistoryEvent {
  const RefreshPaymentsEvent();
}

enum PaymentFilter { all, paid, pending, failed }