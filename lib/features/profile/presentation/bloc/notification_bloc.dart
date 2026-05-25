import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/no_params.dart';
import '../../domain/usecases/get_notifications_usecase.dart';
import '../../domain/usecases/get_unread_count_usecase.dart';
import '../../domain/usecases/mark_all_read_usecase.dart';
import '../../domain/usecases/mark_notification_read_usecase.dart';
import 'notification_event.dart';
import 'notification_state.dart';

@injectable
class NotificationBloc
    extends Bloc<NotificationEvent, NotificationState> {
  NotificationBloc(
    this._getNotificationsUseCase,
    this._markReadUseCase,
    this._markAllReadUseCase,
    this._getUnreadCountUseCase,
  ) : super(const NotificationInitialState()) {
    on<LoadNotificationsEvent>(_onLoad);
    on<MarkNotificationReadEvent>(_onMarkRead);
    on<MarkAllNotificationsReadEvent>(_onMarkAllRead);
    on<RefreshUnreadCountEvent>(_onRefreshCount);
  }

  final GetNotificationsUseCase _getNotificationsUseCase;
  final MarkNotificationReadUseCase _markReadUseCase;
  final MarkAllReadUseCase _markAllReadUseCase;
  final GetUnreadCountUseCase _getUnreadCountUseCase;

  Future<void> _onLoad(
  LoadNotificationsEvent event,
  Emitter<NotificationState> emit,
) async {
  emit(const NotificationLoadingState());

  final notificationsResult = await _getNotificationsUseCase(const NoParams());
  final countResult = await _getUnreadCountUseCase(const NoParams());

  notificationsResult.fold(
    (failure) => emit(
      NotificationErrorState(message: _mapFailure(failure)),
    ),
    (notifications) {
      if (notifications.isEmpty) {
        emit(const NotificationEmptyState());
        return;
      }

      final unreadCount = countResult.fold(
        (_) => 0,
        (count) => count,
      );

      emit(
        NotificationLoadedState(
          notifications: notifications,
          unreadCount: unreadCount,
        ),
      );
    },
  );
}

  Future<void> _onMarkRead(
    MarkNotificationReadEvent event,
    Emitter<NotificationState> emit,
  ) async {
    await _markReadUseCase(
      MarkNotificationReadParams(
        notificationId: event.notificationId,
      ),
    );

    // Reload to reflect updated read status
    add(const LoadNotificationsEvent());
  }

  Future<void> _onMarkAllRead(
    MarkAllNotificationsReadEvent event,
    Emitter<NotificationState> emit,
  ) async {
    await _markAllReadUseCase(const NoParams());
    add(const LoadNotificationsEvent());
  }

  Future<void> _onRefreshCount(
    RefreshUnreadCountEvent event,
    Emitter<NotificationState> emit,
  ) async {
    final result =
        await _getUnreadCountUseCase(const NoParams());

    final current = state;
    if (current is NotificationLoadedState) {
      result.fold(
        (_) {},
        (count) => emit(
          NotificationLoadedState(
            notifications: current.notifications,
            unreadCount: count,
          ),
        ),
      );
    }
  }

  String _mapFailure(Failure failure) {
    return switch (failure) {
      NetworkFailure() => 'No internet connection.',
      _ => 'Could not load notifications.',
    };
  }
}