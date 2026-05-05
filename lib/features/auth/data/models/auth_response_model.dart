import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/entities/auth_entity.dart';


part 'auth_response_model.freezed.dart';
part 'auth_response_model.g.dart';

@freezed
class AuthResponseModel with _$AuthResponseModel {
  
  const factory AuthResponseModel({
    required String accessToken,
    required String refreshToken,
    required String userId,
    required String email,
    int? expiresAt,
  }) = _AuthResponseModel;

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) =>
      _$AuthResponseModelFromJson(json);

  factory AuthResponseModel.fromSupabaseResponse(AuthResponse response) {
    final session = response.session!;
    final user = response.user!;
    return AuthResponseModel(
      accessToken: session.accessToken,
      refreshToken: session.refreshToken!,
      userId: user.id,
      email: user.email ?? '',
      expiresAt: session.expiresAt,
    );
  }
}

extension AuthResponseModelX on AuthResponseModel {
  AuthEntity toEntity() => AuthEntity(
        accessToken: accessToken,
        refreshToken: refreshToken,
        userId: userId,
        email: email,
        expiresAt: expiresAt,
      );
}