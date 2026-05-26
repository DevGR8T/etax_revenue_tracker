import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:etax_revenue_tracker/core/errors/failures.dart';
import 'package:etax_revenue_tracker/core/services/notification_service.dart';
import 'package:etax_revenue_tracker/features/auth/domain/usecases/login_usecase.dart';
import 'package:etax_revenue_tracker/features/auth/domain/usecases/logout_usecase.dart';
import 'package:etax_revenue_tracker/features/auth/domain/usecases/register_usecase.dart';
import 'package:etax_revenue_tracker/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:etax_revenue_tracker/features/auth/presentation/bloc/auth_event.dart';
import 'package:etax_revenue_tracker/features/auth/presentation/bloc/auth_state.dart';
import 'package:etax_revenue_tracker/core/usecases/no_params.dart';
import '../../../../helpers/mock_repositories.dart';
import '../../../../helpers/test_data.dart';

class MockLoginUseCase extends Mock implements LoginUseCase {}
class MockRegisterUseCase extends Mock implements RegisterUseCase {}
class MockLogoutUseCase extends Mock implements LogoutUseCase {}
class MockNotificationService extends Mock implements NotificationService {}

void main() {
  late AuthBloc bloc;
  late MockLoginUseCase mockLoginUseCase;
  late MockRegisterUseCase mockRegisterUseCase;
  late MockLogoutUseCase mockLogoutUseCase;
  late MockAuthRepository mockAuthRepository;
  late MockNotificationService mockNotificationService;

  setUpAll(() {
    registerFallbackValue(
      const LoginParams(email: '', password: ''),
    );
    registerFallbackValue(
      const RegisterParams(email: '', password: ''),
    );
    registerFallbackValue(const NoParams());
  });

  setUp(() {
    mockLoginUseCase = MockLoginUseCase();
    mockRegisterUseCase = MockRegisterUseCase();
    mockLogoutUseCase = MockLogoutUseCase();
    mockAuthRepository = MockAuthRepository();
    mockNotificationService = MockNotificationService();

    bloc = AuthBloc(
      mockLoginUseCase,
      mockRegisterUseCase,
      mockLogoutUseCase,
      mockAuthRepository,
       mockNotificationService,
    );
  });

  tearDown(() => bloc.close());

  group('AuthBloc', () {
    group('LoginEvent', () {
      blocTest<AuthBloc, AuthState>(
        'emits [Loading, Authenticated] on successful login',
        build: () {
          when(() => mockLoginUseCase(any())).thenAnswer(
            (_) async => const Right(TestData.authEntity),
          );
          return bloc;
        },
        act: (bloc) => bloc.add(
          const LoginEvent(
            email: TestData.loginEmail,
            password: TestData.loginPassword,
          ),
        ),
        expect: () => [
          const AuthLoadingState(),
          const AuthenticatedState(entity: TestData.authEntity),
        ],
      );

      blocTest<AuthBloc, AuthState>(
        'emits [Loading, Error] on login failure',
        build: () {
          when(() => mockLoginUseCase(any())).thenAnswer(
            (_) async => const Left(
              AuthFailure(message: 'Incorrect email or password'),
            ),
          );
          return bloc;
        },
        act: (bloc) => bloc.add(
          const LoginEvent(
            email: 'wrong@email.com',
            password: 'wrongpassword',
          ),
        ),
        expect: () => [
          const AuthLoadingState(),
          isA<AuthErrorState>(),
        ],
      );

      blocTest<AuthBloc, AuthState>(
        'emits [Loading, Error] with network message on NetworkFailure',
        build: () {
          when(() => mockLoginUseCase(any())).thenAnswer(
            (_) async => const Left(NetworkFailure()),
          );
          return bloc;
        },
        act: (bloc) => bloc.add(
          const LoginEvent(
            email: TestData.loginEmail,
            password: TestData.loginPassword,
          ),
        ),
        expect: () => [
          const AuthLoadingState(),
          isA<AuthErrorState>().having(
            (s) => s.message,
            'message',
            contains('internet'),
          ),
        ],
      );

      blocTest<AuthBloc, AuthState>(
        'Loading state emitted BEFORE Authenticated — never skipped',
        build: () {
          when(() => mockLoginUseCase(any())).thenAnswer(
            (_) async => const Right(TestData.authEntity),
          );
          return bloc;
        },
        act: (bloc) => bloc.add(
          const LoginEvent(
            email: TestData.loginEmail,
            password: TestData.loginPassword,
          ),
        ),
        expect: () => [
          const AuthLoadingState(),
          isA<AuthenticatedState>(),
        ],
        verify: (_) {
          verify(() => mockLoginUseCase(any())).called(1);
        },
      );
    });

    group('RegisterEvent', () {
      blocTest<AuthBloc, AuthState>(
        'emits [Loading, Authenticated] on successful registration',
        build: () {
          when(() => mockRegisterUseCase(any())).thenAnswer(
            (_) async => const Right(TestData.authEntity),
          );
          return bloc;
        },
        act: (bloc) => bloc.add(
          const RegisterEvent(
            email: TestData.registerEmail,
            password: TestData.registerPassword,
          ),
        ),
        expect: () => [
          const AuthLoadingState(),
          const AuthenticatedState(entity: TestData.authEntity),
        ],
      );

      blocTest<AuthBloc, AuthState>(
        'emits [Loading, Error] on registration failure',
        build: () {
          when(() => mockRegisterUseCase(any())).thenAnswer(
            (_) async => const Left(
              AuthFailure(message: 'Email already registered'),
            ),
          );
          return bloc;
        },
        act: (bloc) => bloc.add(
          const RegisterEvent(
            email: 'taken@email.com',
            password: 'Password1',
          ),
        ),
        expect: () => [
          const AuthLoadingState(),
          isA<AuthErrorState>(),
        ],
      );
    });
group('LogoutEvent', () {
  blocTest<AuthBloc, AuthState>(
    'emits [Loading, Unauthenticated] on logout',
    build: () {
      when(() => mockNotificationService.deleteToken())
          .thenAnswer((_) async => Future.value());
      when(() => mockLogoutUseCase(any()))
          .thenAnswer((_) async => const Right(null));
      return bloc;
    },
    act: (bloc) => bloc.add(const LogoutEvent()),
    expect: () => [
      const AuthLoadingState(),
      const UnauthenticatedState(),
    ],
  );
});

    group('CheckAuthStatusEvent', () {
      blocTest<AuthBloc, AuthState>(
        'emits Authenticated when token exists',
        build: () {
          when(() => mockAuthRepository.isLoggedIn())
              .thenAnswer((_) async => true);
          when(() => mockAuthRepository.getAccessToken())
              .thenAnswer((_) async => 'valid_token');
          when(() => mockAuthRepository.getUserId())
              .thenAnswer(
                (_) async => 'a1b2c3d4-e5f6-7890-abcd-ef1234567890',
              );
          return bloc;
        },
        act: (bloc) => bloc.add(const CheckAuthStatusEvent()),
        expect: () => [isA<AuthenticatedState>()],
      );

      blocTest<AuthBloc, AuthState>(
        'emits Unauthenticated when no token',
        build: () {
          when(() => mockAuthRepository.isLoggedIn())
              .thenAnswer((_) async => false);
          return bloc;
        },
        act: (bloc) => bloc.add(const CheckAuthStatusEvent()),
        expect: () => [const UnauthenticatedState()],
      );
    });
  });
}