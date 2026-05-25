import 'package:etax_revenue_tracker/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:etax_revenue_tracker/features/auth/presentation/bloc/auth_event.dart';
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
import '../../../../shared/widgets/app_loading_widget.dart';
import '../bloc/notification_bloc.dart';
import '../bloc/notification_event.dart';
import '../bloc/notification_state.dart';
import '../bloc/profile_bloc.dart';
import '../bloc/profile_event.dart';
import '../bloc/profile_state.dart';
import '../widgets/avatar_circle.dart';
import '../widgets/logout_button.dart';
import '../widgets/notification_item.dart';
import '../widgets/profile_info_row.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => getIt<ProfileBloc>()..add(const LoadProfileEvent()),
        ),
        BlocProvider(
          create: (_) =>
              getIt<NotificationBloc>()..add(const LoadNotificationsEvent()),
        ),
      ],
      child: const _ProfileView(),
    );
  }
}

class _ProfileView extends StatelessWidget {
  const _ProfileView();

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProfileBloc, ProfileState>(
      listener: (context, state) {
        if (state is ProfileLoggedOutState) {
          context.go(RouteNames.login);
        }
      },
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: Text(AppStrings.profile, style: AppTextStyles.h4),
            actions: [
              // Mark all read button in notifications tab
              BlocBuilder<NotificationBloc, NotificationState>(
                builder: (context, state) {
                  if (state is NotificationLoadedState &&
                      state.unreadCount > 0) {
                    return TextButton(
                      onPressed: () => context.read<NotificationBloc>().add(
                        const MarkAllNotificationsReadEvent(),
                      ),
                      child: Text(
                        'Mark all read',
                        style: AppTextStyles.labelMedium.copyWith(
                          color: AppColors.primary,
                        ),
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ],
            bottom: TabBar(
              labelColor: AppColors.primary,
              unselectedLabelColor: AppColors.grey400,
              indicatorColor: AppColors.primary,
              tabs: [
                const Tab(text: AppStrings.profile),
                Tab(
                  child: BlocBuilder<NotificationBloc, NotificationState>(
                    builder: (context, state) {
                      final unread = state is NotificationLoadedState
                          ? state.unreadCount
                          : 0;

                      return Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(AppStrings.notifications),
                          if (unread > 0) ...[
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.error,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                unread > 99 ? '99+' : unread.toString(),
                                style: AppTextStyles.labelSmall.copyWith(
                                  color: AppColors.white,
                                  fontSize: 10,
                                ),
                              ),
                            ),
                          ],
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          body: const TabBarView(
            children: [_ProfileTab(), _NotificationsTab()],
          ),
        ),
      ),
    );
  }
}

// ── Profile Tab ──────────────────────────────────────────────────

class _ProfileTab extends StatelessWidget {
  const _ProfileTab();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        return switch (state) {
          ProfileLoadingState() => const AppLoadingWidget(),

          ProfileLoadedState(:final profile) => SingleChildScrollView(
            padding: AppSpacing.screenPadding,
            child: Column(
              children: [
                AppSpacing.gapLG,

                // Avatar
                AvatarCircle(
                  initials: profile.initials,
                  radius: 44,
                  avatarUrl: profile.avatarUrl,
                  backgroundColor: AppColors.primary,
                ),
                AppSpacing.gapMD,

                // Full name
                Text(profile.fullName, style: AppTextStyles.h3),
                AppSpacing.gapXS,

                // Email
                Text(
                  profile.email,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.grey500,
                  ),
                ),
                AppSpacing.gapXL,

                // Profile info rows
                const Divider(height: 1),
                ProfileInfoRow(
                  label: 'Tax ID (TIN)',
                  value: profile.tin,
                  icon: Icons.badge_outlined,
                  isMonospace: true,
                ),
                const Divider(height: 1),
                ProfileInfoRow(
                  label: 'State of Residence',
                  value: profile.stateOfResidence,
                  icon: Icons.location_on_outlined,
                ),
                const Divider(height: 1),
                ProfileInfoRow(
                  label: 'Phone Number',
                  value: profile.phone,
                  icon: Icons.phone_outlined,
                ),
                const Divider(height: 1),
                ProfileInfoRow(
                  label: 'Email Address',
                  value: profile.email,
                  icon: Icons.email_outlined,
                ),
                const Divider(height: 1),

                AppSpacing.gapXL,

                // Logout
                LogoutButton(
                  isLoading: false,
                  onConfirm: () =>
                      context.read<AuthBloc>().add(const LogoutEvent()),
                ),
                AppSpacing.gapMD,
              ],
            ),
          ),

          ProfileErrorState(:final message) => AppErrorWidget(
            message: message,
            onRetry: () =>
                context.read<ProfileBloc>().add(const LoadProfileEvent()),
          ),

          _ => const AppLoadingWidget(),
        };
      },
    );
  }
}

// ── Notifications Tab ────────────────────────────────────────────

class _NotificationsTab extends StatelessWidget {
  const _NotificationsTab();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotificationBloc, NotificationState>(
      builder: (context, state) {
        return switch (state) {
          NotificationLoadingState() => const AppLoadingWidget(),

          NotificationLoadedState(:final notifications) => RefreshIndicator(
            color: AppColors.primary,
            onRefresh: () async {
              context.read<NotificationBloc>().add(
                const LoadNotificationsEvent(),
              );
              await Future.delayed(const Duration(milliseconds: 500));
            },
            child: ListView.separated(
              itemCount: notifications.length,
              separatorBuilder: (_, _) => const Divider(height: 1),
              itemBuilder: (_, index) => NotificationItem(
                notification: notifications[index],
                onTap: () => context.read<NotificationBloc>().add(
                  MarkNotificationReadEvent(
                    notificationId: notifications[index].id,
                  ),
                ),
              ),
            ),
          ),

          NotificationEmptyState() => const AppEmptyWidget(
            icon: Icons.notifications_off_outlined,
            message: AppStrings.noNotifications,
            subtitle: AppStrings.noNotificationsSubtitle,
          ),

          NotificationErrorState(:final message) => AppErrorWidget(
            message: message,
            onRetry: () => context.read<NotificationBloc>().add(
              const LoadNotificationsEvent(),
            ),
          ),

          _ => const AppLoadingWidget(),
        };
      },
    );
  }
}
