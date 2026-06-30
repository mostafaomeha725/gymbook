import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gymbook/core/services/notification_service.dart';
import 'package:gymbook/core/services/signalr_service.dart';
import 'package:gymbook/features/notifications/domain/entities/notification_entity.dart';
import 'package:gymbook/features/notifications/domain/usecases/get_in_app_notifications_usecase.dart';
import 'package:gymbook/features/notifications/domain/usecases/mark_notification_as_read_usecase.dart';
import 'package:gymbook/features/notifications/domain/usecases/update_fcm_token_usecase.dart';
import 'package:gymbook/features/notifications/domain/usecases/get_unread_notification_count_usecase.dart';
import 'package:gymbook/features/notifications/presentation/cubits/notifications_cubit/notifications_state.dart';
import 'package:gymbook/core/widgets/in_app_notification_popup/in_app_notification_popup.dart';
import 'package:gymbook/core/services/notification_refresh_service.dart';

class NotificationsCubit extends Cubit<NotificationsState> {
  final UpdateFcmTokenUseCase updateFcmTokenUseCase;
  final NotificationService notificationService;
  final SignalRService signalRService;
  final GetInAppNotificationsUseCase getInAppNotificationsUseCase;
  final MarkNotificationAsReadUseCase markNotificationAsReadUseCase;
  final GetUnreadNotificationCountUseCase getUnreadNotificationCountUseCase;

  StreamSubscription? _tokenSubscription;
  StreamSubscription? _signalRSubscription;

  bool isEnabled = false;
  List<NotificationEntity> _notifications = [];
  int _badgeCount = 0;
  bool _hasFetchedInitial = false;

  NotificationsCubit({
    required this.updateFcmTokenUseCase,
    required this.notificationService,
    required this.signalRService,
    required this.getInAppNotificationsUseCase,
    required this.markNotificationAsReadUseCase,
    required this.getUnreadNotificationCountUseCase,
  }) : super(NotificationsInitial()) {
    _listenToSignalR();
  }

  void _listenToSignalR() {
    _signalRSubscription = signalRService.notificationStream.listen((
      notification,
    ) {
      _notifications = [notification, ..._notifications];
      _badgeCount++;
      _emitLoaded();
      InAppNotificationPopup.show(notification);
      // Notify relevant screens to refresh
      NotificationRefreshService().notifyRefresh(notification.notificationType);
    });
  }

  void _emitLoaded() {
    emit(
      NotificationsLoaded(
        notifications: _notifications,
        badgeCount: _badgeCount,
      ),
    );
  }

  Future<void> fetchNotifications() async {
    if (_hasFetchedInitial) {
      _emitLoaded();
      return;
    }

    emit(NotificationsLoading());
    final result = await getInAppNotificationsUseCase();
    result.fold((failure) => emit(NotificationsError(failure.message)), (
      notifications,
    ) {
      _notifications = notifications;
      _hasFetchedInitial = true;
      _emitLoaded();
    });
  }

  Future<void> fetchUnreadCount() async {
    final result = await getUnreadNotificationCountUseCase();
    result.fold(
      (failure) => null,
      (count) {
        _badgeCount = count;
        _emitLoaded();
      },
    );
  }

  Future<void> markAsRead(int id) async {
    final index = _notifications.indexWhere((n) => n.id == id);
    if (index != -1 && !_notifications[index].isRead) {
      _notifications[index] = _notifications[index].copyWith(isRead: true);
      if (_badgeCount > 0) _badgeCount--;
      _emitLoaded();

      await markNotificationAsReadUseCase(id);
    }
  }

  Future<void> checkStatus() async {
    emit(NotificationsStatusLoading());
    isEnabled = await notificationService.isNotificationEnabled();
    emit(NotificationsStatusLoaded(isEnabled));
  }

  Future<void> toggleNotifications(bool enable) async {
    emit(NotificationsToggling());
    if (enable) {
      final granted = await notificationService.requestPermission();
      if (granted) {
        isEnabled = true;
        await initNotifications();
        emit(const NotificationsToggled(true));
        emit(const NotificationsStatusLoaded(true));
      } else {
        isEnabled = false;
        emit(
          const NotificationsError(
            'Please enable notifications from device settings',
          ),
        );
        emit(const NotificationsStatusLoaded(false));
      }
    } else {
      try {
        await notificationService.deleteToken();
        await updateFcmTokenUseCase("");
      } catch (e) {
        // ignore
      }
      isEnabled = false;
      emit(const NotificationsToggled(false));
      emit(const NotificationsStatusLoaded(false));
    }
  }

  Future<void> initNotifications() async {
    await notificationService.init();

    // Get initial token and update backend
    final token = await notificationService.getToken();
    if (token != null) {
      await _updateToken(token);
    }

    // Listen for token refreshes
    _tokenSubscription = notificationService.onTokenRefresh.listen((newToken) {
      _updateToken(newToken);
    });

    // Fetch initial unread count
    await fetchUnreadCount();
  }

  Future<void> _updateToken(String token) async {
    if (isClosed) return;
    emit(NotificationsTokenUpdating());
    final result = await updateFcmTokenUseCase(token);
    if (isClosed) return;
    result.fold(
      (failure) => emit(NotificationsTokenUpdateError(failure.message)),
      (_) => emit(NotificationsTokenUpdated()),
    );
  }

  void resetState() {
    _notifications = [];
    _badgeCount = 0;
    _hasFetchedInitial = false;
    _emitLoaded();
  }

  @override
  Future<void> close() {
    _tokenSubscription?.cancel();
    _signalRSubscription?.cancel();
    return super.close();
  }
}
