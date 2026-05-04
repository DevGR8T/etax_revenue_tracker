import 'package:equatable/equatable.dart';

class AuthEntity extends Equatable {
  const AuthEntity({
    required this.accessToken,
    required this.refreshToken,
    required this.userId,
    required this.email,
    this.expiresAt,
  });

  /// The JWT access token stored in Flutter Secure Storage.
  final String accessToken;

  /// The refresh token used to get a new access token.
  
  final String refreshToken;

  final String userId;

  /// Citizen email address.
  final String email;

  /// Used to check if token needs refresh before API calls.
  final int? expiresAt;

  @override
  List<Object?> get props => [
        accessToken,
        refreshToken,
        userId,
        email,
        expiresAt,
      ];
}