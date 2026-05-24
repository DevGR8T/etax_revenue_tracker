import 'package:freezed_annotation/freezed_annotation.dart';

part 'create_payment_request_model.freezed.dart';
part 'create_payment_request_model.g.dart';

/// Request body for POST /products/add.
/// DummyJSON echoes this back with a generated id.
/// We use that id for the receipt number.
@freezed
class CreatePaymentRequestModel with _$CreatePaymentRequestModel {
  const factory CreatePaymentRequestModel({
    /// Maps levyType → title
    required String title,

    /// Maps amount → price
    required double price,

    /// Maps levyType → category
    required String category,

    /// Maps notes → description
    required String description,
  }) = _CreatePaymentRequestModel;

  factory CreatePaymentRequestModel.fromJson(
    Map<String, dynamic> json,
  ) =>
      _$CreatePaymentRequestModelFromJson(json);
}