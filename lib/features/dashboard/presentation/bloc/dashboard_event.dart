import 'package:equatable/equatable.dart';

abstract class DashboardEvent extends Equatable {
  const DashboardEvent();

  @override
  List<Object?> get props => [];
}

/// Fired automatically on screen creation.
class LoadDashboardEvent extends DashboardEvent {
  const LoadDashboardEvent();
}

/// Fired on pull-to-refresh.
/// Shows shimmer briefly then loads fresh data.
class RefreshDashboardEvent extends DashboardEvent {
  const RefreshDashboardEvent();
}