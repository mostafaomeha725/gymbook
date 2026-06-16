import 'package:gymbook/core/network/endpoints.dart';
import 'package:gymbook/core/network/network_service.dart';

abstract class NotificationsRemoteDataSource {
  Future<void> updateFcmToken(String token);
}

class NotificationsRemoteDataSourceImpl
    implements NotificationsRemoteDataSource {
  final NetworkService _networkService;

  NotificationsRemoteDataSourceImpl(this._networkService);

  @override
  Future<void> updateFcmToken(String token) async {
    await _networkService.postData(
      endPoint: EndPoints.updateFcmToken,
      data: {'fcmToken': token},
    );
  }
}
