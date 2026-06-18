import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gymbook/core/services/notification_service.dart';
import 'package:gymbook/features/notifications/domain/usecases/update_fcm_token_usecase.dart';
import 'package:gymbook/features/notifications/presentation/cubits/notifications_cubit/notifications_state.dart';

class NotificationsCubit extends Cubit<NotificationsState> {
  final UpdateFcmTokenUseCase updateFcmTokenUseCase;
  final NotificationService notificationService;
  StreamSubscription? _tokenSubscription;

  bool isEnabled = false;

  NotificationsCubit({
    required this.updateFcmTokenUseCase,
    required this.notificationService,
  }) : super(NotificationsInitial());

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
        emit(NotificationsToggled(true));
        emit(NotificationsStatusLoaded(true));
      } else {
        isEnabled = false;
        emit(NotificationsError('Please enable notifications from device settings'));
        emit(NotificationsStatusLoaded(false));
      }
    } else {
      try {
        await notificationService.deleteToken();
        await updateFcmTokenUseCase("");
      } catch (e) {
        // ignore
      }
      isEnabled = false;
      emit(NotificationsToggled(false));
      emit(NotificationsStatusLoaded(false));
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
  }

  Future<void> _updateToken(String token) async {
    emit(NotificationsTokenUpdating());
    final result = await updateFcmTokenUseCase(token);
    result.fold(
      (failure) => emit(NotificationsTokenUpdateError(failure.message)),
      (_) => emit(NotificationsTokenUpdated()),
    );
  }

  @override
  Future<void> close() {
    _tokenSubscription?.cancel();
    return super.close();
  }
}
