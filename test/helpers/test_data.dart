import 'package:etax_revenue_tracker/features/auth/domain/entities/auth_entity.dart';
import 'package:etax_revenue_tracker/features/dashboard/domain/entities/dashboard_entity.dart';
import 'package:etax_revenue_tracker/features/dashboard/domain/entities/recent_payment_entity.dart';
import 'package:etax_revenue_tracker/features/payments/domain/entities/payment_entity.dart';
import 'package:etax_revenue_tracker/features/payments/domain/repositories/payment_repository.dart';
import 'package:etax_revenue_tracker/features/profile/domain/entities/notification_entity.dart';
import 'package:etax_revenue_tracker/features/profile/domain/entities/profile_entity.dart';

abstract final class TestData {
  // ── Auth ───────────────────────────────────────────────────
  /// SUPABASE: accessToken + refreshToken + userId (UUID) + email
  static const authEntity = AuthEntity(
    accessToken: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.test',
    refreshToken: 'test_refresh_token_abc123',
    userId: 'a1b2c3d4-e5f6-7890-abcd-ef1234567890',
    email: 'testcitizen@etax.ng',
  );

  static const loginEmail = 'testcitizen@etax.ng';
  static const loginPassword = 'Test1234!';
  static const registerEmail = 'newcitizen@etax.ng';
  static const registerPassword = 'Test1234!';

  // ── Payment ────────────────────────────────────────────────
  static final paymentEntity = PaymentEntity(
    id: 1,
    levyName: 'Essence Mascara Lash Princess',
    levyType: 'beauty',
    description: 'A product description',
    amount: 9.99,
    formattedAmount: '₦9.99',
    date: DateTime(2024, 1, 5),
    formattedDate: 'Jan 5, 2024',
    status: PaymentStatus.pending,
    receiptNumber: 'RCP-2024-00001',
    taxId: 'NG-12345678',
    issuedBy: 'Enugu State Internal Revenue Service',
  );

  static final paymentEntityPaid = PaymentEntity(
    id: 3,
    levyName: 'Property Tax',
    levyType: 'Property Tax',
    description: 'Annual property tax',
    amount: 5000,
    formattedAmount: '₦5,000.00',
    date: DateTime(2024, 3, 10),
    formattedDate: 'Mar 10, 2024',
    status: PaymentStatus.paid,
    receiptNumber: 'RCP-2024-00003',
    taxId: 'NG-12345678',
    issuedBy: 'Enugu State Internal Revenue Service',
  );

  static final paymentList = [paymentEntity, paymentEntityPaid];

  static final paymentListResult = PaymentListResult(
    payments: paymentList,
    total: 194,
    skip: 0,
    limit: 10,
  );

  static const emptyPaymentListResult = PaymentListResult(
    payments: [],
    total: 0,
    skip: 0,
    limit: 10,
  );

  // ── Dashboard ──────────────────────────────────────────────
  static final recentPayment = RecentPaymentEntity(
    id: 1,
    levyName: 'Property Tax',
    amount: 5000,
    formattedAmount: '₦5,000.00',
    date: DateTime(2024, 1, 5),
    formattedDate: 'Jan 5, 2024',
    status: PaymentStatus.paid,
    statusLabel: 'Paid',
    receiptNumber: 'RCP-2024-00001',
  );

  static final dashboardEntity = DashboardEntity(
    citizenName: 'Emily Johnson',
    tin: 'NG-12345678',
    totalPaid: 5000,
    outstanding: 9.99,
    receiptCount: 194,
    recentPayments: [recentPayment],
  );

  // ── Profile ────────────────────────────────────────────────
  /// SUPABASE: added supabaseUserId field
  static const profileEntity = ProfileEntity(
    id: 1,
    fullName: 'Emily Johnson',
    firstName: 'Emily',
    lastName: 'Johnson',
    email: 'testcitizen@etax.ng',
    phone: '+81 965-431-3024',
    tin: 'NG-12345678',
    stateOfResidence: 'FCT (Abuja)',
    initials: 'EJ',
    supabaseUserId: 'a1b2c3d4-e5f6-7890-abcd-ef1234567890',
  );

  // ── Notifications ──────────────────────────────────────────
  static final notificationEntity = NotificationEntity(
    id: 'notif_001',
    title: 'Tax Reminder',
    body: 'Your property tax is due in 3 days',
    timestamp: DateTime(2024, 3, 10, 14, 30),
    isRead: false,
  );

  static final readNotificationEntity = NotificationEntity(
    id: 'notif_002',
    title: 'Payment Confirmed',
    body: 'Your payment of ₦5,000.00 was successful',
    timestamp: DateTime(2024, 3, 9, 10, 0),
    isRead: true,
  );

  static final notificationList = [
    notificationEntity,
    readNotificationEntity,
  ];
}