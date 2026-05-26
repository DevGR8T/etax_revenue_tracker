import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:etax_revenue_tracker/core/errors/failures.dart';
import 'package:etax_revenue_tracker/features/payments/domain/entities/payment_list_params.dart';
import 'package:etax_revenue_tracker/features/payments/domain/usecases/get_payments_usecase.dart';
import '../../../../helpers/mock_repositories.dart';
import '../../../../helpers/test_data.dart';

void main() {
  late GetPaymentsUseCase useCase;
  late MockPaymentRepository mockRepository;

  setUpAll(() {
    registerFallbackValue(const PaymentListParams());
  });

  setUp(() {
    mockRepository = MockPaymentRepository();
    useCase = GetPaymentsUseCase(mockRepository);
  });

  const params = PaymentListParams(limit: 10, skip: 0);

  group('GetPaymentsUseCase', () {
    test(
      'returns PaymentListResult on success',
      () async {
        // Arrange
        when(() => mockRepository.getPayments(any()))
            .thenAnswer(
          (_) async => Right(TestData.paymentListResult),
        );

        // Act
        final result = await useCase(params);

        // Assert
        expect(result.isRight(), true);
        result.fold(
          (_) => fail('Expected Right'),
          (listResult) {
            expect(listResult.payments, isNotEmpty);
            expect(listResult.total, 194);
            expect(listResult.payments.length, 2);
          },
        );
      },
    );

    test(
      'returns empty list result when no payments exist',
      () async {
        // Arrange
        when(() => mockRepository.getPayments(any()))
            .thenAnswer(
          (_) async => const Right(TestData.emptyPaymentListResult),
        );

        // Act
        final result = await useCase(params);

        // Assert
        expect(result.isRight(), true);
        result.fold(
          (_) => fail('Expected Right'),
          (listResult) {
            expect(listResult.payments, isEmpty);
            expect(listResult.total, 0);
          },
        );
      },
    );

    test(
      'returns NetworkFailure when offline',
      () async {
        // Arrange
        when(() => mockRepository.getPayments(any()))
            .thenAnswer(
          (_) async => const Left(NetworkFailure()),
        );

        // Act
        final result = await useCase(params);

        // Assert
        expect(result, const Left(NetworkFailure()));
      },
    );

    test(
      'returns ServerFailure on API error',
      () async {
        // Arrange
        const failure = ServerFailure(
          message: 'Server error',
          statusCode: 500,
        );
        when(() => mockRepository.getPayments(any()))
            .thenAnswer((_) async => const Left(failure));

        // Act
        final result = await useCase(params);

        // Assert
        expect(result, const Left(failure));
      },
    );

    test(
      'hasReachedEnd is false when more pages exist',
      () async {
        // Arrange
        when(() => mockRepository.getPayments(any()))
            .thenAnswer(
          (_) async => Right(TestData.paymentListResult),
        );

        // Act
        final result = await useCase(params);

        // Assert
        result.fold(
          (_) => fail('Expected Right'),
          (listResult) {
            // total=194, skip=0, limit=10 — not at end
            expect(listResult.hasReachedEnd, false);
          },
        );
      },
    );

    test(
      'passes correct limit and skip to repository',
      () async {
        // Arrange
        when(() => mockRepository.getPayments(any()))
            .thenAnswer(
          (_) async => Right(TestData.paymentListResult),
        );

        const pageTwoParams = PaymentListParams(
          limit: 10,
          skip: 10,
        );

        // Act
        await useCase(pageTwoParams);

        // Assert
        verify(
          () => mockRepository.getPayments(pageTwoParams),
        ).called(1);
      },
    );
  });
}