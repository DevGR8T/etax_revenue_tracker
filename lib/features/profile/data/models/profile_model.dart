import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../core/utils/receipt_generator.dart';
import '../../../../core/utils/extensions/string_extensions.dart';
import '../../domain/entities/profile_entity.dart';

part 'profile_model.freezed.dart';
part 'profile_model.g.dart';

/// Maps DummyJSON GET /users/1 response.
/// Only fields we actually use — confirmed in Postman Day 2.
/// All other fields from the 30+ field response are ignored.
@freezed
class ProfileModel with _$ProfileModel {
  const factory ProfileModel({
    required int id,
    required String firstName,
    required String lastName,
    required String email,
    required String phone,

    /// Confirmed nullable in Postman Day 2.
    String? image,
  }) = _ProfileModel;

  factory ProfileModel.fromJson(Map<String, dynamic> json) =>
      _$ProfileModelFromJson(json);
}

extension ProfileModelX on ProfileModel {
  /// Convert model to domain entity.
  ///
  /// SUPABASE NOTE:
  /// supabaseUserId is the UUID from Supabase SecureStorage.
  /// We use ReceiptGenerator.tinFromUuid() for stable TIN generation.
  /// Falls back to int-based TIN if no Supabase session found.
  /// supabaseEmail overrides DummyJSON email — citizen registered
  /// with their real email in Supabase, not DummyJSON test email.
  ProfileEntity toEntity({
    String? stateOfResidence,
    String? supabaseUserId,
    String? supabaseEmail,
  }) {
    final fullName = '$firstName $lastName';

    // Generate TIN from Supabase UUID if available
    final tin = (supabaseUserId != null && supabaseUserId.isNotEmpty)
        ? ReceiptGenerator.tinFromUuid(supabaseUserId)
        : ReceiptGenerator.tin(id);

    // Use Supabase email if available — citizen's real registered email
    final resolvedEmail = (supabaseEmail != null && supabaseEmail.isNotEmpty)
        ? supabaseEmail
        : email;

    return ProfileEntity(
      id: id,
      fullName: fullName,
      firstName: firstName,
      lastName: lastName,
      email: resolvedEmail,
      phone: phone,
      tin: tin,
      stateOfResidence: stateOfResidence ?? 'Nigeria',
      initials: fullName.initials,
      avatarUrl: image,
      supabaseUserId: supabaseUserId,
    );
  }
}