import 'package:equatable/equatable.dart';

/// Parameters for payment search with pagination.
class SearchPaymentsParams extends Equatable {
  const SearchPaymentsParams({
    required this.query,
    this.limit = 10,
    this.skip = 0,
  });

  final String query;
  final int limit;
  final int skip;

  @override
  List<Object?> get props => [query, limit, skip];
}