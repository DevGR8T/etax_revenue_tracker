import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/payment_entity.dart';
import '../../domain/entities/payment_status.dart';
import '../../../../core/utils/receipt_generator.dart';
import '../../../../core/constants/app_strings.dart';

part 'payment_model.freezed.dart';
part 'payment_model.g.dart';

/// Maps DummyJSON GET /products/{id} response.
/// Every field documented in Postman
@freezed
class PaymentModel with _$PaymentModel {
  const factory PaymentModel({
    required int id,
    required String title,

    /// price is double not int — confirmed in Postman 
    required double price,
    required String category,
    required String description,

    /// Confirmed nullable in Postman — use null check everywhere.
    String? thumbnail,

    /// Nested meta — contains createdAt timestamp.
    PaymentMetaModel? meta,
  }) = _PaymentModel;

  factory PaymentModel.fromJson(Map<String, dynamic> json) =>
      _$PaymentModelFromJson(json);
}

@freezed
class PaymentMetaModel with _$PaymentMetaModel {
  const factory PaymentMetaModel({
    String? createdAt,
    String? updatedAt,
  }) = _PaymentMetaModel;

  factory PaymentMetaModel.fromJson(Map<String, dynamic> json) =>
      _$PaymentMetaModelFromJson(json);
}

/// Converts model to domain entity.
/// All derivation logic lives here.
///
/// SUPABASE NOTE:
/// storedUserId is now a UUID String from Supabase — not an int.
/// We use ReceiptGenerator.tinFromUuid() to generate a stable TIN.
/// Falls back to int-based TIN if storedUserId cannot be parsed as UUID.
extension PaymentModelX on PaymentModel {
  PaymentEntity toEntity({String? storedUserId}) {
    // Derive status — same id always gets same status
    final status = PaymentStatus.fromId(id);

    // Parse date — fallback to simulated date if missing
    DateTime date;
    try {
      date = DateTime.parse(meta?.createdAt ?? '');
    } catch (_) {
      date = DateTime.now().subtract(Duration(days: id));
    }

    final formattedDate = DateFormat('MMM d, yyyy').format(date);

    // Format amount as ₦4,500.00
    final formattedAmount = NumberFormat.currency(
      locale: 'en_NG',
      symbol: '₦',
      decimalDigits: 2,
    ).format(price);

    // Generate TIN from Supabase UUID string
    // If storedUserId looks like a UUID use tinFromUuid
    // Otherwise fall back to int-based tin
    final String taxId;
    if (storedUserId != null && storedUserId.contains('-')) {
      // UUID format contains hyphens — confirmed Supabase UUID shape
      taxId = ReceiptGenerator.tinFromUuid(storedUserId);
    } else {
      final userId = int.tryParse(storedUserId ?? '') ?? 1;
      taxId = ReceiptGenerator.tin(userId);
    }

    return PaymentEntity(
      id: id,
      levyName: title,
      levyType: category,
      description: description,
      amount: price,
      formattedAmount: formattedAmount,
      date: date,
      formattedDate: formattedDate,
      status: status,
      receiptNumber: ReceiptGenerator.receiptNumber(id),
      taxId: taxId,
      issuedBy: AppStrings.issuingAuthority,
      thumbnailUrl: thumbnail,
    );
  }
}