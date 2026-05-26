import 'package:mocktail/mocktail.dart';
import 'package:etax_revenue_tracker/features/auth/domain/repositories/auth_repository.dart';
import 'package:etax_revenue_tracker/features/dashboard/domain/repositories/dashboard_repository.dart';
import 'package:etax_revenue_tracker/features/payments/domain/repositories/payment_repository.dart';
import 'package:etax_revenue_tracker/features/profile/domain/repositories/notification_repository.dart';
import 'package:etax_revenue_tracker/features/profile/domain/repositories/profile_repository.dart';

/// Mocktail mocks for all repository interfaces.
/// Used in UseCase and BLoC tests.
/// Real repositories never touched in tests.

class MockAuthRepository extends Mock implements AuthRepository {}

class MockDashboardRepository extends Mock
    implements DashboardRepository {}

class MockPaymentRepository extends Mock
    implements PaymentRepository {}

class MockProfileRepository extends Mock
    implements ProfileRepository {}

class MockNotificationRepository extends Mock
    implements NotificationRepository {}