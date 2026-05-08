import 'package:freezed_annotation/freezed_annotation.dart';

part 'login_request_model.freezed.dart';
part 'login_request_model.g.dart';

/// Login request parameters.
/// Supabase SDK accepts email + password directly —
/// this model exists for consistency and testability.
@freezed
class LoginRequestModel with _$LoginRequestModel {
  
  const factory LoginRequestModel({
    required String email,
    required String password,
  }) = _LoginRequestModel;

  factory LoginRequestModel.fromJson(Map<String, dynamic> json) =>
      _$LoginRequestModelFromJson(json);
}