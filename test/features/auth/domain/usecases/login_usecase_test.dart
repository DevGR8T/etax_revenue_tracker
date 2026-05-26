import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:etax_revenue_tracker/core/errors/failures.dart';
import 'package:etax_revenue_tracker/features/auth/domain/usecases/login_usecase.dart';
import '../../../../helpers/mock_repositories.dart';
import '../../../../helpers/test_data.dart';

void main() {
  late LoginUseCase useCase;
  late MockAuthRepository mockRepository;

  setUp(() {
    mockRepository = MockAuthRepository();
    useCase = LoginUseCase(mockRepository);
  });

  const params = LoginParams(
    email: TestData.loginEmail,
    password: TestData.loginPassword,
  );

  group('LoginUseCase', () {
    test(
      'returns AuthEntity on successful login',
      () async {
        // Arrange
        when(
          () => mockRepository.login(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenAnswer((_) async => const Right(TestData.authEntity));

        // Act
        final result = await useCase(params);

        // Assert
        expect(result, const Right(TestData.authEntity));
        verify(
          () => mockRepository.login(
            email: TestData.loginEmail,
            password: TestData.loginPassword,
          ),
        ).called(1);
      },
    );

    test(
      'returns AuthFailure when credentials are invalid',
      () async {
        // Arrange
        const failure = AuthFailure(
          message: 'Incorrect email or password',
        );
        when(
          () => mockRepository.login(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenAnswer((_) async => const Left(failure));

        // Act
        final result = await useCase(params);

        // Assert
        expect(result, const Left(failure));
      },
    );

    test(
      'returns NetworkFailure when no internet connection',
      () async {
        // Arrange
        when(
          () => mockRepository.login(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenAnswer((_) async => const Left(NetworkFailure()));

        // Act
        final result = await useCase(params);

        // Assert
        expect(result, const Left(NetworkFailure()));
      },
    );

    test(
      'returns ServerFailure on server error',
      () async {
        // Arrange
        const failure = ServerFailure(
          message: 'Server error. Please try again later.',
          statusCode: 500,
        );
        when(
          () => mockRepository.login(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenAnswer((_) async => const Left(failure));

        // Act
        final result = await useCase(params);

        // Assert
        expect(result, const Left(failure));
      },
    );

    test(
      'calls repository with exact email and password',
      () async {
        // Arrange
        when(
          () => mockRepository.login(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenAnswer((_) async => const Right(TestData.authEntity));

        // Act
        await useCase(params);

        // Assert — exact values passed to repository
        verify(
          () => mockRepository.login(
            email: TestData.loginEmail,
            password: TestData.loginPassword,
          ),
        ).called(1);

        verifyNoMoreInteractions(mockRepository);
      },
    );
  });
}