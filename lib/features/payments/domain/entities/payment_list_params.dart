import 'package:equatable/equatable.dart';

/// Parameters for paginated payment history.
class PaymentListParams extends Equatable {
  const PaymentListParams({
    this.limit = 10,
    this.skip = 0,
  });

  final int limit;
  final int skip;

  @override
  List<Object?> get props => [limit, skip];
}