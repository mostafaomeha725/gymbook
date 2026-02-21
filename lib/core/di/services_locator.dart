import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:gymbook/core/cache/preferences_storage.dart';
import 'package:gymbook/core/network/network_service.dart';
import 'package:gymbook/features/auth/presentation/cubits/login_cubit/login_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sl = GetIt.instance;

class ServiceLocator {
  Future<void> init() async {
    /// Core Services
    await _initStorage();
    _initDio();

    /// Features
    _initAuth();
    // _initHome();
  }

  /// =============================
  /// STORAGE
  /// =============================
  Future<void> _initStorage() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    sl.registerLazySingleton(() => sharedPreferences);
    sl.registerLazySingleton(() => PreferencesStorage(sl()));
  }

  /// =============================
  /// NETWORK
  /// =============================
  void _initDio() {
    sl.registerLazySingleton(() => Dio());
    sl.registerLazySingleton(() => NetworkService(sl()));
  }

  /// =============================
  /// AUTH FEATURE
  /// =============================
  void _initAuth() {
    sl.registerFactory(() => LoginCubit(sl()));
  }

  // /// =============================
  // /// HOME FEATURE
  // /// =============================
  // void _initHome() {
  //   sl.registerLazySingleton(() => HomeRepository(sl()));
  //   sl.registerFactory(() => HomeCubit(sl()));
  // }
}
