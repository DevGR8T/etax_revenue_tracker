import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/router/route_names.dart';
import '../../../../shared/widgets/app_empty_widget.dart';
import '../../../../shared/widgets/app_error_widget.dart';
import '../bloc/payment_history_bloc.dart';
import '../bloc/payment_history_event.dart';
import '../bloc/payment_history_state.dart';
import '../widgets/filter_chips_row.dart';
import '../widgets/payment_list_item.dart';
import '../widgets/payment_list_shimmer.dart';
import '../widgets/search_bar.dart';

class PaymentHistoryScreen extends StatelessWidget {
  const PaymentHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<PaymentHistoryBloc>()
        ..add(const LoadPaymentsEvent()),
      child: const _PaymentHistoryView(),
    );
  }
}

class _PaymentHistoryView extends StatefulWidget {
  const _PaymentHistoryView();

  @override
  State<_PaymentHistoryView> createState() => _PaymentHistoryViewState();
}

class _PaymentHistoryViewState extends State<_PaymentHistoryView> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  /// Fire LoadMorePaymentsEvent when 200px from bottom.
  void _onScroll() {
    if (!_scrollController.hasClients) return;

    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;

    if (currentScroll >= maxScroll - 200.0) {
      final state = context.read<PaymentHistoryBloc>().state;
      if (state is PaymentHistoryLoadedState && !state.hasReachedEnd) {
        context
            .read<PaymentHistoryBloc>()
            .add(const LoadMorePaymentsEvent());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.paymentHistory, style: AppTextStyles.h4),
      ),
      body: Column(
        children: [
          // Search bar — always visible
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: PaymentSearchBar(
              onChanged: (query) {
                context
                    .read<PaymentHistoryBloc>()
                    .add(SearchPaymentsEvent(query: query));
              },
              onClear: () {
                context
                    .read<PaymentHistoryBloc>()
                    .add(const ClearSearchEvent());
              },
            ),
          ),

          // Filter chips — shown when list data is present
          BlocBuilder<PaymentHistoryBloc, PaymentHistoryState>(
            buildWhen: (prev, curr) =>
                curr is PaymentHistoryLoadedState ||
                curr is PaymentHistoryLoadingMoreState ||
                curr is PaymentHistoryEndOfListState,
            builder: (context, state) {
              PaymentFilter activeFilter = PaymentFilter.all;
              if (state is PaymentHistoryLoadedState) {
                activeFilter = state.activeFilter;
              } else if (state is PaymentHistoryLoadingMoreState) {
                activeFilter = state.activeFilter;
              } else if (state is PaymentHistoryEndOfListState) {
                activeFilter = state.activeFilter;
              }

              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: FilterChipsRow(
                  activeFilter: activeFilter,
                  onFilterChanged: (filter) {
                    context
                        .read<PaymentHistoryBloc>()
                        .add(FilterPaymentsEvent(filter: filter));
                  },
                ),
              );
            },
          ),

          // Main content area
          Expanded(
            child: BlocBuilder<PaymentHistoryBloc, PaymentHistoryState>(
              builder: (context, state) {
                return switch (state) {
                  PaymentHistoryLoadingState() => const PaymentListShimmer(),

                  PaymentHistoryLoadedState(
                    :final filteredPayments,
                  ) =>
                    RefreshIndicator(
                      color: AppColors.primary,
                      onRefresh: () async {
                        context
                            .read<PaymentHistoryBloc>()
                            .add(const RefreshPaymentsEvent());
                        await Future.delayed(
                            const Duration(milliseconds: 500));
                      },
                      child: ListView.separated(
                        controller: _scrollController,
                        itemCount: filteredPayments.length,
                        separatorBuilder: (_, __) => const Divider(height: 1),
                        itemBuilder: (_, index) => PaymentListItem(
                          payment: filteredPayments[index],
                          onTap: () => context.go(
                            RouteNames.paymentDetailPath(
                              filteredPayments[index].id.toString(),
                            ),
                          ),
                        ),
                      ),
                    ),

                  PaymentHistoryLoadingMoreState(
                    :final filteredPayments,
                  ) =>
                    Column(
                      children: [
                        Expanded(
                          child: ListView.separated(
                            controller: _scrollController,
                            itemCount: filteredPayments.length,
                            separatorBuilder: (_, __) =>
                                const Divider(height: 1),
                            itemBuilder: (_, index) => PaymentListItem(
                              payment: filteredPayments[index],
                              onTap: () => context.go(
                                RouteNames.paymentDetailPath(
                                  filteredPayments[index].id.toString(),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.all(16),
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              AppColors.primary,
                            ),
                          ),
                        ),
                      ],
                    ),

                  PaymentHistoryEndOfListState(:final filteredPayments) =>
                    ListView.separated(
                      controller: _scrollController,
                      itemCount: filteredPayments.length + 1,
                      separatorBuilder: (_, __) => const Divider(height: 1),
                      itemBuilder: (_, index) {
                        if (index == filteredPayments.length) {
                          return Padding(
                            padding: AppSpacing.cardPadding,
                            child: Center(
                              child: Text(
                                AppStrings.allPaymentsLoaded,
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: AppColors.grey400,
                                ),
                              ),
                            ),
                          );
                        }
                        return PaymentListItem(
                          payment: filteredPayments[index],
                          onTap: () => context.go(
                            RouteNames.paymentDetailPath(
                              filteredPayments[index].id.toString(),
                            ),
                          ),
                        );
                      },
                    ),

                  PaymentHistoryEmptySearchState(:final query) =>
                    AppEmptyWidget(
                      icon: Icons.search_off_rounded,
                      message: query.isEmpty
                          ? AppStrings.noPaymentsFound
                          : '${AppStrings.noSearchResults} "$query"',
                      subtitle:
                          query.isEmpty ? null : 'Try a different search term',
                    ),

                  PaymentHistoryErrorState(:final message) => AppErrorWidget(
                      message: message,
                      onRetry: () => context
                          .read<PaymentHistoryBloc>()
                          .add(const LoadPaymentsEvent()),
                    ),

                  _ => const PaymentListShimmer(),
                };
              },
            ),
          ),
        ],
      ),
    );
  }
}