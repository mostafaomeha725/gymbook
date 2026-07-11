import 'dart:io';
import 'package:gymbook/core/network/endpoints.dart';
import 'package:gymbook/core/network/network_service.dart';
import 'package:gymbook/features/notifications/data/models/notification_model.dart';

abstract class NotificationsRemoteDataSource {
  Future<void> updateFcmToken(String token);
  Future<List<NotificationModel>> getInAppNotifications();
  Future<int> getUnreadNotificationCount();
  Future<void> markNotificationAsRead(int id);
}

class NotificationsRemoteDataSourceImpl
    implements NotificationsRemoteDataSource {
  final NetworkService _networkService;

  NotificationsRemoteDataSourceImpl(this._networkService);

  @override
  Future<void> updateFcmToken(String token) async {
    await _networkService.postData(
      endPoint: EndPoints.updateFcmToken,
      data: {'token': token, 'devicePlatform': Platform.isIOS ? 1 : 0},
    );
  }

  @override
  Future<List<NotificationModel>> getInAppNotifications() async {
    final response = await _networkService.getData(
      endPoint: EndPoints.getInAppNotifications,
    );

    return response.fold((failure) => throw failure, (data) {
      final List<dynamic> list = data['data'] ?? [];
      return list.map((json) => NotificationModel.fromJson(json)).toList();
    });
  }

  @override
  Future<void> markNotificationAsRead(int id) async {
    await _networkService.putData(
      endPoint: EndPoints.markNotificationAsRead(id),
      data: {},
    );
  }

  @override
  Future<int> getUnreadNotificationCount() async {
    final response = await _networkService.getData(
      endPoint: EndPoints.getUnreadNotificationCount,
    );

    return response.fold(
      (failure) => throw failure,
      (data) => data['unreadCount'] ?? 0,
    );
  }
}
