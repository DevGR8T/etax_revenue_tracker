import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:etax_revenue_tracker/core/errors/failures.dart';
import 'package:etax_revenue_tracker/features/auth/domain/usecases/register_usecase.dart';
import '../../../../helpers/mock_repositories.dart';
import '../../../../helpers/test_data.dart';

void main() {
  late RegisterUseCase useCase;
  late MockAuthRepository mockRepository;

  setUp(() {
    mockRepository = MockAuthRepository();
    useCase = RegisterUseCase(mockRepository);
  });

  const params = RegisterParams(
    email: TestData.registerEmail,
    password: TestData.registerPassword,
  );

  group('RegisterUseCase', () {
    test('returns AuthEntity with id on successful registration', () async {
      // Arrange
      when(
        () => mockRepository.register(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenAnswer((_) async => const Right(TestData.authEntity));

      // Act
      final result = await useCase(params);

      // Assert
      expect(result.isRight(), true);
      result.fold((_) => fail('Expected Right'), (entity) {
        expect(entity.accessToken, isNotEmpty);
        expect(entity.userId, isNotNull);
      });
    });

    test('returns AuthFailure when email is already registered', () async {
      // Arrange
      const failure = AuthFailure(message: 'Email already registered');
      when(
        () => mockRepository.register(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenAnswer((_) async => const Left(failure));

      // Act
      final result = await useCase(params);

      // Assert
      expect(result, const Left(failure));
    });

    test('returns NetworkFailure when offline', () async {
      // Arrange
      when(
        () => mockRepository.register(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenAnswer((_) async => const Left(NetworkFailure()));

      // Act
      final result = await useCase(params);

      // Assert
      expect(result, const Left(NetworkFailure()));
    });

    test('calls repository exactly once with correct params', () async {
      // Arrange
      when(
        () => mockRepository.register(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenAnswer((_) async => const Right(TestData.authEntity));

      // Act
      await useCase(params);

      // Assert
      verify(
        () => mockRepository.register(
          email: TestData.registerEmail,
          password: TestData.registerPassword,
        ),
      ).called(1);

      verifyNoMoreInteractions(mockRepository);
    });
  });
}
