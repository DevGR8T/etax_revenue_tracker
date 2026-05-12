import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/recent_payment_entity.dart';

part 'recent_payment_model.freezed.dart';
part 'recent_payment_model.g.dart';

/// Maps the DummyJSON GET /products response.
/// Only fields we use — documented in Postman Day 2.
@freezed
class RecentPaymentModel with _$RecentPaymentModel {
  const factory RecentPaymentModel({
    required int id,
    required String title,

    /// price is double not int — confirmed in Postman Day 2
    required double price,
    required String category,
    required String description,

    /// Can be null — confirmed in Postman Day 2.
    String? thumbnail,

    /// Nested meta object containing createdAt timestamp.
    ProductMetaModel? meta,
  }) = _RecentPaymentModel;

  factory RecentPaymentModel.fromJson(Map<String, dynamic> json) =>
      _$RecentPaymentModelFromJson(json);
}

@freezed
class ProductMetaModel with _$ProductMetaModel {
  const factory ProductMetaModel({
    String? createdAt,
    String? updatedAt,
  }) = _ProductMetaModel;

  factory ProductMetaModel.fromJson(Map<String, dynamic> json) =>
      _$ProductMetaModelFromJson(json);
}

/// Extension to convert model to domain entity.
/// All derivation logic lives here — not in the repository.
extension RecentPaymentModelX on RecentPaymentModel {
  RecentPaymentEntity toEntity() {
    // Derive payment status from id as per spec — confirmed Day 2
    final status = switch (id % 3) {
      0 => PaymentStatus.paid,
      1 => PaymentStatus.pending,
      _ => PaymentStatus.failed,
    };

    final statusLabel = switch (status) {
      PaymentStatus.paid => 'Paid',
      PaymentStatus.pending => 'Pending',
      PaymentStatus.failed => 'Failed',
    };

    // Parse date from meta.createdAt — fallback to derived date if null
    DateTime date;
    String formattedDate;
    try {
      date = DateTime.parse(meta?.createdAt ?? '');
      formattedDate = DateFormat('MMM d, yyyy').format(date);
    } catch (_) {
      date = DateTime.now().subtract(Duration(days: id));
      formattedDate = DateFormat('MMM d, yyyy').format(date);
    }

    // Format amount as Nigerian naira
    final formattedAmount = NumberFormat.currency(
      locale: 'en_NG',
      symbol: '₦',
      decimalDigits: 2,
    ).format(price);

    // Generate receipt number
    final receiptNumber = 'RCP-2024-${id.toString().padLeft(5, '0')}';

    return RecentPaymentEntity(
      id: id,
      levyName: title,
      amount: price,
      formattedAmount: formattedAmount,
      date: date,
      formattedDate: formattedDate,
      status: status,
      statusLabel: statusLabel,
      receiptNumber: receiptNumber,
      levyType: category,
      description: description,
    );
  }
}

/// Response wrapper for paginated products list.
@freezed
class ProductsListModel with _$ProductsListModel {
  const factory ProductsListModel({
    required List<RecentPaymentModel> products,
    required int total,
    required int skip,
    required int limit,
  }) = _ProductsListModel;

  factory ProductsListModel.fromJson(Map<String, dynamic> json) =>
      _$ProductsListModelFromJson(json);
}