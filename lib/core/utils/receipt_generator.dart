import 'package:crypto/crypto.dart';
import 'dart:convert';

/// Generates consistent receipt and TIN numbers.
/// Used across PaymentDetail, PayTax, Dashboard, and Profile.
/// IMPORTANT: Supabase userId is a UUID String, not an int.
/// We use a stable hash of the UUID to generate an 8-digit TIN.
/// This ensures the same UUID always produces the same TIN.
abstract final class ReceiptGenerator {
  /// Generates receipt number from payment id.
 static String receiptNumber(int id) {
  final year = DateTime.now().year;
  return 'RCP-$year-${id.toString().padLeft(5, '0')}';
}

  /// Generates Tax Identification Number from Supabase UUID string.
static String tinFromUuid(String uuid) {
  final bytes = utf8.encode(uuid);
  final hash = md5.convert(bytes).toString();
  final number = int.parse(hash.substring(0, 8), radix: 16) % 100000000;
  return 'NG-${number.toString().padLeft(8, '0')}';
}

  /// Legacy — kept for DummyJSON user id (int) compatibility.
  /// Use tinFromUuid for Supabase users.
  static String tin(int userId) =>
      'NG-${userId.toString().padLeft(8, '0')}';
}