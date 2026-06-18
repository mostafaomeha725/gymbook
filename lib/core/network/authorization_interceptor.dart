import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:gymbook/core/cache/preferences_storage.dart';
import 'package:gymbook/core/constants/strings.dart';
import 'package:gymbook/core/di/services_locator.dart';
import 'package:gymbook/core/network/endpoints.dart';

class AuthorizationInterceptor extends Interceptor {
  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final prefs = sl<PreferencesStorage>();

    final token = prefs.getUserToken();

    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = "Bearer $token";
    }

    handler.next(options);
  }

  @override
  Future<void> onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      final prefs = sl<PreferencesStorage>();
      final accessToken = prefs.getUserToken();
      final refreshToken = prefs.getRefreshToken();

      if (accessToken != null && refreshToken != null) {
        try {
          final dio = Dio(BaseOptions(baseUrl: AppStrings.baseUrl));
          
          final refreshResponse = await dio.post(
            EndPoints.refreshToken,
            data: {
              'accessToken': accessToken,
              'refreshToken': refreshToken,
            },
          );

          if (refreshResponse.statusCode == 200) {
            final data = refreshResponse.data;
            final newAccessToken = data['accessToken'];
            final newRefreshToken = data['refreshToken']['token'];

            await prefs.saveUserToken(newAccessToken);
            await prefs.saveRefreshToken(newRefreshToken);

            // Retry original request with new token
            err.requestOptions.headers['Authorization'] = "Bearer $newAccessToken";
            
            final retryDio = Dio(BaseOptions(baseUrl: AppStrings.baseUrl));
            final retryResponse = await retryDio.fetch(err.requestOptions);
            
            return handler.resolve(retryResponse);
          }
        } catch (e) {
          // If refresh token fails, log out
          await prefs.deleteUserToken();
          await prefs.deleteRefreshToken();
          debugPrint("Refresh token failed → unauthenticated");
        }
      } else {
        await prefs.deleteUserToken();
        await prefs.deleteRefreshToken();
      }
    }
    handler.next(err);
  }
}
