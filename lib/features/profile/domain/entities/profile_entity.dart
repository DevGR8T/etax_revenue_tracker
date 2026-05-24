import 'package:equatable/equatable.dart';

/// Complete citizen profile.
/// Pure Dart — no JSON, no Flutter, no Dio.
/// Combines DummyJSON user data with Supabase auth data
/// and locally stored registration data.
///
/// SUPABASE NOTE:
/// userId is now a UUID String — not an int.
/// id field kept as int for DummyJSON user compatibility.
/// supabaseUserId stored separately for TIN generation.
class ProfileEntity extends Equatable {
  const ProfileEntity({
    required this.id,
    required this.fullName,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.tin,
    required this.stateOfResidence,
    required this.initials,
    this.avatarUrl,
    this.supabaseUserId,
  });

  /// DummyJSON user id — int.
  final int id;

  /// firstName + lastName combined.
  final String fullName;

  final String firstName;
  final String lastName;

  /// Email from Supabase auth — overrides DummyJSON email.
  final String email;

  final String phone;

  /// Generated from Supabase UUID via ReceiptGenerator.tinFromUuid().
  /// Falls back to int-based TIN if no Supabase session.
  final String tin;

  /// From registration — stored in SharedPreferences.
  final String stateOfResidence;

  /// First letters of first and last name — JD for John Doe.
  final String initials;

  /// Maps from DummyJSON user.image — nullable.
  final String? avatarUrl;

  /// Supabase UUID — stored for reference and downstream use.
  final String? supabaseUserId;

  @override
  List<Object?> get props => [
        id,
        fullName,
        email,
        phone,
        tin,
        stateOfResidence,
      ];
}