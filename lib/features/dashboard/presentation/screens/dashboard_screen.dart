import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/di/injection.dart';
import '../../../../shared/widgets/app_error_widget.dart';
import '../../../../shared/widgets/notification_badge.dart';
import '../../../../shared/widgets/section_header.dart';
import '../bloc/dashboard_bloc.dart';
import '../bloc/dashboard_event.dart';
import '../bloc/dashboard_state.dart';
import '../widgets/greeting_header.dart';
import '../widgets/quick_actions_bar.dart';
import '../widgets/recent_payment_row.dart';
import '../widgets/stat_card.dart';
import '../widgets/stat_card_shimmer.dart';
import '../widgets/tin_card.dart';
import '../../domain/entities/dashboard_entity.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<DashboardBloc>()
        ..add(const LoadDashboardEvent()),
      child: const _DashboardView(),
    );
  }
}

class _DashboardView extends StatelessWidget {
  const _DashboardView();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DashboardBloc, DashboardState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              AppStrings.appName,
              style: AppTextStyles.h4,
            ),
            actions: [
              NotificationBadge(
                // Notification count wired on Day 12 with Firebase
                count: 0,
                onTap: () => context.go(RouteNames.profile),
              ),
              AppSpacing.gapHSM,
            ],
          ),
          body: switch (state) {
            DashboardLoadingState() => const _DashboardShimmer(),
            DashboardLoadedState(:final entity) =>
              _DashboardContent(entity: entity),
            DashboardRefreshingState(:final entity) =>
              _DashboardContent(entity: entity, isRefreshing: true),
            DashboardErrorState(:final message) => AppErrorWidget(
                message: message,
                onRetry: () => context
                    .read<DashboardBloc>()
                    .add(const LoadDashboardEvent()),
              ),
            _ => const _DashboardShimmer(),
          },
        );
      },
    );
  }
}

/// Loaded state — real data visible.
class _DashboardContent extends StatelessWidget {
  const _DashboardContent({
    required this.entity,
    this.isRefreshing = false,
  });

  final DashboardEntity entity;
  final bool isRefreshing;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: AppColors.primary,
      onRefresh: () async {
        context
            .read<DashboardBloc>()
            .add(const RefreshDashboardEvent());
        // Wait for state change
        await Future.delayed(const Duration(milliseconds: 500));
      },
      child: ListView(
        padding: AppSpacing.screenPadding,
        children: [
          AppSpacing.gapSM,

          // Greeting
          GreetingHeader(citizenName: entity.citizenName),
          AppSpacing.gapMD,

          // TIN Card
          TinCard(tin: entity.tin),
          AppSpacing.gapMD,

          // Stat Cards Row
          Row(
            children: [
              Expanded(
                child: StatCard(
                  label: AppStrings.totalPaid,
                  value: entity.totalPaid,
                  accentColor: AppColors.paid,
                  icon: Icons.check_circle_outline_rounded,
                ),
              ),
              AppSpacing.gapHSM,
              Expanded(
                child: StatCard(
                  label: AppStrings.outstanding,
                  value: entity.outstanding,
                  accentColor: AppColors.pending,
                  icon: Icons.pending_outlined,
                ),
              ),
              AppSpacing.gapHSM,
              Expanded(
                child: StatCard(
                  label: AppStrings.receipts,
                  value: entity.receiptCount.toDouble(),
                  accentColor: AppColors.secondary,
                  icon: Icons.receipt_outlined,
                  isCurrency: false,
                ),
              ),
            ],
          ),
          AppSpacing.gapLG,

          // Recent Transactions
          SectionHeader(
            title: AppStrings.recentTransactions,
            onSeeAll: () => context.go(RouteNames.history),
          ),
          AppSpacing.gapSM,

          if (entity.recentPayments.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 32),
              child: Center(
                child: Text(
                  'No recent transactions',
                  style: TextStyle(color: AppColors.grey400),
                ),
              ),
            )
          else
            ...entity.recentPayments.map(
              (payment) => Column(
                children: [
                  RecentPaymentRow(
                    payment: payment,
                    onTap: () => context.go(
                      RouteNames.paymentDetailPath(
                        payment.id.toString(),
                      ),
                    ),
                  ),
                  const Divider(height: 1),
                ],
              ),
            ),

          AppSpacing.gapLG,

          // Quick Actions
          const SectionHeader(title: 'Quick Actions'),
          AppSpacing.gapSM,
          QuickActionsBar(
            onPayNow: () => context.go(RouteNames.payTax),
            onHistory: () => context.go(RouteNames.history),
            onProfile: () => context.go(RouteNames.profile),
          ),

          AppSpacing.gapXL,
        ],
      ),
    );
  }
}

/// Shimmer loading state.
/// Matches exact dimensions of real content.
class _DashboardShimmer extends StatelessWidget {
  const _DashboardShimmer();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Shimmer.fromColors(
      baseColor: isDark
          ? AppColors.shimmerBaseDark
          : AppColors.shimmerBase,
      highlightColor: isDark
          ? AppColors.shimmerHighlightDark
          : AppColors.shimmerHighlight,
      child: ListView(
        padding: AppSpacing.screenPadding,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          AppSpacing.gapSM,

          // Greeting shimmer
          Container(
            width: 120,
            height: 14,
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          AppSpacing.gapXS,
          Container(
            width: 180,
            height: 22,
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          AppSpacing.gapMD,

          // TIN card shimmer
          Container(
            width: double.infinity,
            height: 100,
            decoration: const BoxDecoration(
              color: AppColors.white,
              borderRadius: AppSpacing.borderRadiusLG,
            ),
          ),
          AppSpacing.gapMD,

          // Stat cards shimmer
          const Row(
            children: [
              Expanded(child: StatCardShimmer()),
              SizedBox(width: 8),
              Expanded(child: StatCardShimmer()),
              SizedBox(width: 8),
              Expanded(child: StatCardShimmer()),
            ],
          ),
          AppSpacing.gapLG,

          // Section header shimmer
          Container(
            width: 160,
            height: 18,
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          AppSpacing.gapSM,

          // Payment rows shimmer
          ...List.generate(
            5,
            (_) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: const BoxDecoration(
                      color: AppColors.white,
                      borderRadius: AppSpacing.borderRadiusSM,
                    ),
                  ),
                  AppSpacing.gapHMD,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 14,
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        AppSpacing.gapXS,
                        Container(
                          width: 80,
                          height: 11,
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ],
                    ),
                  ),
                  AppSpacing.gapHMD,
                  Container(
                    width: 60,
                    height: 14,
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}