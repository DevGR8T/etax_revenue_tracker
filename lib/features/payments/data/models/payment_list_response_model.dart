import 'package:freezed_annotation/freezed_annotation.dart';
import 'payment_model.dart';

part 'payment_list_response_model.freezed.dart';
part 'payment_list_response_model.g.dart';

/// Maps DummyJSON paginated products response.
/// GET /products?limit=10&skip=0
/// GET /products/search?q={query}
/// Both endpoints return this exact shape — confirmed in Postman Day 2.
@freezed
class PaymentListResponseModel with _$PaymentListResponseModel {
  const factory PaymentListResponseModel({
    required List<PaymentModel> products,
    required int total,
    required int skip,
    required int limit,
  }) = _PaymentListResponseModel;

  factory PaymentListResponseModel.fromJson(Map<String, dynamic> json) =>
      _$PaymentListResponseModelFromJson(json);
}