import 'package:equatable/equatable.dart';
import '../../domain/entities/dashboard_entity.dart';

abstract class DashboardState extends Equatable {
  const DashboardState();

  @override
  List<Object?> get props => [];
}

/// Initial — before any load has happened.
class DashboardInitialState extends DashboardState {
  const DashboardInitialState();
}

/// Loading — shimmer cards showing.
/// Never show a blank screen.
class DashboardLoadingState extends DashboardState {
  const DashboardLoadingState();
}

/// Loaded — real data visible.
class DashboardLoadedState extends DashboardState {
  const DashboardLoadedState({required this.entity});

  final DashboardEntity entity;

  @override
  List<Object?> get props => [entity];
}

/// Error — friendly message + retry button.
class DashboardErrorState extends DashboardState {
  const DashboardErrorState({required this.message});

  final String message;

  @override
  List<Object?> get props => [message];
}

/// Refreshing — pull to refresh in progress.
/// Keeps current data visible while refreshing.
class DashboardRefreshingState extends DashboardState {
  const DashboardRefreshingState({required this.entity});

  final DashboardEntity entity;

  @override
  List<Object?> get props => [entity];
}