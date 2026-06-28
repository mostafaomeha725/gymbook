import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:gymbook/core/cache/preferences_storage.dart';
import 'package:gymbook/core/di/services_locator.dart';
import 'package:gymbook/core/network/endpoints.dart';
import 'package:gymbook/core/network/network_service.dart';
import 'package:gymbook/core/services/signalr_service.dart';
import 'package:gymbook/core/utils/safe_print.dart';

class AuthorizationInterceptor extends Interceptor {
  bool _isRefreshing = false;
  final List<Completer<bool>> _requestsQueue = [];

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final prefs = sl<PreferencesStorage>();
    final token = prefs.getUserToken();

    if (options.path.contains(EndPoints.refreshToken)) {
      // DO NOT send expired token in header for refresh request!
      options.headers.remove('Authorization');
    } else if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = "Bearer $token";
    }

    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (err.response?.statusCode == 401 &&
        !err.requestOptions.path.contains(EndPoints.refreshToken) &&
        err.requestOptions.extra['isRetry'] != true) {

      if (_isRefreshing) {
        final completer = Completer<bool>();
        _requestsQueue.add(completer);

        final isRefreshSuccess = await completer.future;

        if (isRefreshSuccess) {
          final prefs = sl<PreferencesStorage>();
          final newAccessToken = prefs.getUserToken();
          if (newAccessToken != null) {
            err.requestOptions.headers['Authorization'] =
                'Bearer $newAccessToken';
            err.requestOptions.extra['isRetry'] = true;
            try {
              final retryResponse = await sl<NetworkService>().dio.fetch(
                err.requestOptions,
              );
              return handler.resolve(retryResponse);
            } catch (retryError) {
              if (retryError is DioException) {
                return handler.next(retryError);
              }
              return handler.next(err);
            }
          }
        }
        return handler.next(err);
      }

      _isRefreshing = true;
      bool refreshSuccess = false;
      String? newAccessToken;

      try {
        final prefs = sl<PreferencesStorage>();

        final accessToken = prefs.getUserToken();
        final refreshToken = prefs.getRefreshToken();

        if (accessToken != null && refreshToken != null) {
          final networkService = sl<NetworkService>();

          final requestBody = {
            'accessToken': accessToken,
            'refreshToken': refreshToken,
          };

          final refreshResult = await networkService.postData(
            endPoint: EndPoints.refreshToken,
            data: requestBody,
          );

          await refreshResult.fold(
            (failure) async {
              EasyLoading.showError(
                failure.message,
                duration: const Duration(seconds: 5),
              );
              refreshSuccess = false;
            },
            (data) async {
              newAccessToken = data['accessToken'];
              final newRefreshToken = data['refreshToken']['token'];

              await prefs.saveUserToken(newAccessToken!);
              await prefs.saveRefreshToken(newRefreshToken);

              // Update the global NetworkService Dio instance!
              networkService.addToken(newAccessToken!);

              safePrint("Restart SignalR After Refresh");
              await sl<SignalRService>().reconnect();

              refreshSuccess = true;
            },
          );
        }
      } catch (e) {
        refreshSuccess = false;
      } finally {
        _isRefreshing = false;
        for (var completer in _requestsQueue) {
          completer.complete(refreshSuccess);
        }
        _requestsQueue.clear();
      }

      if (refreshSuccess && newAccessToken != null) {
        try {
          err.requestOptions.headers['Authorization'] =
              'Bearer $newAccessToken';
          err.requestOptions.extra['isRetry'] = true;

          final retryResponse = await sl<NetworkService>().dio.fetch(
            err.requestOptions,
          );

          return handler.resolve(retryResponse);
        } catch (retryError) {
          if (retryError is DioException) {
            return handler.next(retryError);
          }

          return handler.next(err);
        }
      } else {
        final prefs = sl<PreferencesStorage>();
        await prefs.deleteUserToken();
        await prefs.deleteRefreshToken();
      }
    }

    handler.next(err);
  }
}

