/// Payment status derived from product id.
/// id % 3 == 0 → paid
/// id % 3 == 1 → pending
/// id % 3 == 2 → failed
///
/// Same id always gets same status — consistent across
/// Dashboard, History, and Receipt screens.
enum PaymentStatus {
  paid,
  pending,
  failed;

  /// Human readable label shown in UI.
  String get label => switch (this) {
        PaymentStatus.paid => 'Paid',
        PaymentStatus.pending => 'Pending',
        PaymentStatus.failed => 'Failed',
      };

  /// Derive status from any product id.
  static PaymentStatus fromId(int id) => switch (id % 3) {
        0 => PaymentStatus.paid,
        1 => PaymentStatus.pending,
        _ => PaymentStatus.failed,
      };
}