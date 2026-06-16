import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gymbook/core/services/notification_service.dart';
import 'package:gymbook/features/notifications/domain/usecases/update_fcm_token_usecase.dart';
import 'package:gymbook/features/notifications/presentation/cubits/notifications_cubit/notifications_state.dart';

class NotificationsCubit extends Cubit<NotificationsState> {
  final UpdateFcmTokenUseCase updateFcmTokenUseCase;
  final NotificationService notificationService;
  StreamSubscription? _tokenSubscription;

  NotificationsCubit({
    required this.updateFcmTokenUseCase,
    required this.notificationService,
  }) : super(NotificationsInitial());

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
