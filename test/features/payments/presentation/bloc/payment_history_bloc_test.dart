import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:etax_revenue_tracker/core/errors/failures.dart';
import 'package:etax_revenue_tracker/features/payments/domain/entities/payment_list_params.dart';
import 'package:etax_revenue_tracker/features/payments/domain/entities/search_payments_params.dart';
import 'package:etax_revenue_tracker/features/payments/domain/repositories/payment_repository.dart';
import 'package:etax_revenue_tracker/features/payments/domain/usecases/get_payments_usecase.dart';
import 'package:etax_revenue_tracker/features/payments/domain/usecases/search_payments_usecase.dart';
import 'package:etax_revenue_tracker/features/payments/presentation/bloc/payment_history_bloc.dart';
import 'package:etax_revenue_tracker/features/payments/presentation/bloc/payment_history_event.dart';
import 'package:etax_revenue_tracker/features/payments/presentation/bloc/payment_history_state.dart';
import '../../../../helpers/test_data.dart';

class MockGetPaymentsUseCase extends Mock
    implements GetPaymentsUseCase {}

class MockSearchPaymentsUseCase extends Mock
    implements SearchPaymentsUseCase {}

void main() {
  late PaymentHistoryBloc bloc;
  late MockGetPaymentsUseCase mockGetPayments;
  late MockSearchPaymentsUseCase mockSearchPayments;

  setUpAll(() {
    registerFallbackValue(const PaymentListParams());
    registerFallbackValue(
      const SearchPaymentsParams(query: ''),
    );
  });

  setUp(() {
    mockGetPayments = MockGetPaymentsUseCase();
    mockSearchPayments = MockSearchPaymentsUseCase();
    bloc = PaymentHistoryBloc(mockGetPayments, mockSearchPayments);
  });

  tearDown(() => bloc.close());

  group('PaymentHistoryBloc', () {
    group('LoadPaymentsEvent', () {
      blocTest<PaymentHistoryBloc, PaymentHistoryState>(
        'emits [Loading, Loaded] on successful load',
        build: () {
          when(() => mockGetPayments(any())).thenAnswer(
            (_) async => Right(TestData.paymentListResult),
          );
          return bloc;
        },
        act: (bloc) => bloc.add(const LoadPaymentsEvent()),
        expect: () => [
          const PaymentHistoryLoadingState(),
          isA<PaymentHistoryLoadedState>(),
        ],
      );

      blocTest<PaymentHistoryBloc, PaymentHistoryState>(
        'loaded state contains correct payment list',
        build: () {
          when(() => mockGetPayments(any())).thenAnswer(
            (_) async => Right(TestData.paymentListResult),
          );
          return bloc;
        },
        act: (bloc) => bloc.add(const LoadPaymentsEvent()),
        expect: () => [
          const PaymentHistoryLoadingState(),
          isA<PaymentHistoryLoadedState>().having(
            (s) => s.payments.length,
            'payment count',
            TestData.paymentList.length,
          ),
        ],
      );

      blocTest<PaymentHistoryBloc, PaymentHistoryState>(
        'emits [Loading, EmptySearch] when list is empty',
        build: () {
          when(() => mockGetPayments(any())).thenAnswer(
            (_) async => const Right(TestData.emptyPaymentListResult),
          );
          return bloc;
        },
        act: (bloc) => bloc.add(const LoadPaymentsEvent()),
        expect: () => [
          const PaymentHistoryLoadingState(),
          isA<PaymentHistoryEmptySearchState>(),
        ],
      );

      blocTest<PaymentHistoryBloc, PaymentHistoryState>(
        'emits [Loading, Error] on NetworkFailure',
        build: () {
          when(() => mockGetPayments(any())).thenAnswer(
            (_) async => const Left(NetworkFailure()),
          );
          return bloc;
        },
        act: (bloc) => bloc.add(const LoadPaymentsEvent()),
        expect: () => [
          const PaymentHistoryLoadingState(),
          isA<PaymentHistoryErrorState>().having(
            (s) => s.message,
            'error message',
            contains('internet'),
          ),
        ],
      );
    });

    group('LoadMorePaymentsEvent', () {
      blocTest<PaymentHistoryBloc, PaymentHistoryState>(
        'appends new payments to existing list',
        build: () {
          when(() => mockGetPayments(any())).thenAnswer(
            (_) async => Right(
              PaymentListResult(
                payments: TestData.paymentList,
                total: 194,
                skip: 10,
                limit: 10,
              ),
            ),
          );
          return bloc;
        },
        seed: () => PaymentHistoryLoadedState(
          payments: TestData.paymentList,
          filteredPayments: TestData.paymentList,
          total: 194,
          currentSkip: 10,
          activeFilter: PaymentFilter.all,
          hasReachedEnd: false,
        ),
        act: (bloc) => bloc.add(const LoadMorePaymentsEvent()),
        expect: () => [
          isA<PaymentHistoryLoadingMoreState>(),
          isA<PaymentHistoryLoadedState>().having(
            (s) => s.payments.length,
            'total payments after append',
            greaterThan(TestData.paymentList.length),
          ),
        ],
      );

      blocTest<PaymentHistoryBloc, PaymentHistoryState>(
        'does nothing when already at end of list',
        build: () => bloc,
        seed: () => PaymentHistoryLoadedState(
          payments: TestData.paymentList,
          filteredPayments: TestData.paymentList,
          total: 2,
          currentSkip: 10,
          activeFilter: PaymentFilter.all,
          hasReachedEnd: true, // already at end
        ),
        act: (bloc) => bloc.add(const LoadMorePaymentsEvent()),
        expect: () => [], // no state changes
      );
    });

    group('SearchPaymentsEvent', () {
      blocTest<PaymentHistoryBloc, PaymentHistoryState>(
        'emits [Loading, Loaded] with search results',
        build: () {
          when(() => mockSearchPayments(any())).thenAnswer(
            (_) async => Right(TestData.paymentListResult),
          );
          return bloc;
        },
        act: (bloc) => bloc.add(
          const SearchPaymentsEvent(query: 'property'),
        ),
        wait: const Duration(milliseconds: 600),
        expect: () => [
          const PaymentHistoryLoadingState(),
          isA<PaymentHistoryLoadedState>(),
        ],
      );

      blocTest<PaymentHistoryBloc, PaymentHistoryState>(
        'emits EmptySearch when no results found',
        build: () {
          when(() => mockSearchPayments(any())).thenAnswer(
            (_) async =>
                const Right(TestData.emptyPaymentListResult),
          );
          return bloc;
        },
        act: (bloc) => bloc.add(
          const SearchPaymentsEvent(query: 'xxxxxxxxxxx'),
        ),
        wait: const Duration(milliseconds: 600),
        expect: () => [
          const PaymentHistoryLoadingState(),
          isA<PaymentHistoryEmptySearchState>().having(
            (s) => s.query,
            'query stored in state',
            'xxxxxxxxxxx',
          ),
        ],
      );

      blocTest<PaymentHistoryBloc, PaymentHistoryState>(
        'debounce fires only once after rapid typing',
        build: () {
          when(() => mockSearchPayments(any())).thenAnswer(
            (_) async => Right(TestData.paymentListResult),
          );
          return bloc;
        },
        act: (bloc) async {
          // Simulate rapid typing — 5 keystrokes
          bloc.add(const SearchPaymentsEvent(query: 'p'));
          bloc.add(const SearchPaymentsEvent(query: 'pr'));
          bloc.add(const SearchPaymentsEvent(query: 'pro'));
          bloc.add(const SearchPaymentsEvent(query: 'prop'));
          bloc.add(const SearchPaymentsEvent(query: 'property'));
          // Wait for debounce to fire
          await Future.delayed(const Duration(milliseconds: 600));
        },
        verify: (_) {
          // Search API called only ONCE — not 5 times
          verify(() => mockSearchPayments(any())).called(1);
        },
      );
    });

    group('FilterPaymentsEvent', () {
      blocTest<PaymentHistoryBloc, PaymentHistoryState>(
        'filters to paid payments only',
        build: () => bloc,
        seed: () => PaymentHistoryLoadedState(
          payments: TestData.paymentList,
          filteredPayments: TestData.paymentList,
          total: 194,
          currentSkip: 10,
          activeFilter: PaymentFilter.all,
          hasReachedEnd: false,
        ),
        act: (bloc) => bloc.add(
          const FilterPaymentsEvent(filter: PaymentFilter.paid),
        ),
        expect: () => [
          isA<PaymentHistoryLoadedState>().having(
            (s) => s.activeFilter,
            'active filter',
            PaymentFilter.paid,
          ),
        ],
        verify: (_) {
          // No API call — filter is local
          verifyNever(() => mockGetPayments(any()));
          verifyNever(() => mockSearchPayments(any()));
        },
      );

      blocTest<PaymentHistoryBloc, PaymentHistoryState>(
        'shows all payments when All filter selected',
        build: () => bloc,
        seed: () => PaymentHistoryLoadedState(
          payments: TestData.paymentList,
          filteredPayments: [TestData.paymentEntityPaid],
          total: 194,
          currentSkip: 10,
          activeFilter: PaymentFilter.paid,
          hasReachedEnd: false,
        ),
        act: (bloc) => bloc.add(
          const FilterPaymentsEvent(filter: PaymentFilter.all),
        ),
        expect: () => [
          isA<PaymentHistoryLoadedState>().having(
            (s) => s.filteredPayments.length,
            'all payments shown',
            TestData.paymentList.length,
          ),
        ],
      );
    });
  });
}