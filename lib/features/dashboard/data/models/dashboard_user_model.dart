import 'package:freezed_annotation/freezed_annotation.dart';

part 'dashboard_user_model.freezed.dart';
part 'dashboard_user_model.g.dart';

/// Maps the DummyJSON GET /users/1 response.
/// Only the fields we actually need 

@freezed
class DashboardUserModel with _$DashboardUserModel {
  const factory DashboardUserModel({
    required int id,
    required String firstName,
    required String lastName,
    required String email,
    required String phone,

    /// Can be null — confirmed in Postman Day 2.
    String? image,
  }) = _DashboardUserModel;

  factory DashboardUserModel.fromJson(Map<String, dynamic> json) =>
      _$DashboardUserModelFromJson(json);
}