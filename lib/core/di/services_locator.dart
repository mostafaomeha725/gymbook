import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:gymbook/core/cache/preferences_storage.dart';
import 'package:gymbook/core/network/network_service.dart';
import 'package:gymbook/features/admin_home/data/repositories/admin_branch_repository.dart';
import 'package:gymbook/features/admin_home/presentation/cubits/branch_location_cubit/branch_location_cubit.dart';
import 'package:gymbook/features/admin_home/presentation/cubits/branch_working_hours_cubit/branch_working_hours_cubit.dart';
import 'package:gymbook/features/admin_home/presentation/cubits/branches_list_cubit/branches_list_cubit.dart';
import 'package:gymbook/features/admin_home/presentation/cubits/create_branch_cubit/create_branch_cubit.dart';
import 'package:gymbook/features/admin_home/presentation/cubits/create_package_cubit/create_package_cubit.dart';
import 'package:gymbook/features/auth/presentation/cubits/login_cubit/login_cubit.dart';
import 'package:gymbook/features/auth/presentation/cubits/register_cubit/register_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sl = GetIt.instance;

class ServiceLocator {
  Future<void> init() async {
    /// Core Services
    await _initStorage();
    _initDio();

    /// Features
    _initAuth();
    _initAdmin();
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
    if (!sl.isRegistered<LoginCubit>()) {
      sl.registerFactory(() => LoginCubit(sl()));
    }
    if (!sl.isRegistered<RegisterCubit>()) {
      sl.registerFactory(() => RegisterCubit(sl()));
    }
  }

  /// =============================
  /// ADMIN FEATURE
  /// =============================
  void _initAdmin() {
    if (!sl.isRegistered<AdminBranchRepository>()) {
      sl.registerLazySingleton<AdminBranchRepository>(
        () => AdminBranchRepositoryImpl(sl()),
      );
    }

    if (!sl.isRegistered<CreateBranchCubit>()) {
      sl.registerFactory(() => CreateBranchCubit(sl()));
    }

    if (!sl.isRegistered<BranchWorkingHoursCubit>()) {
      sl.registerFactory(() => BranchWorkingHoursCubit(sl()));
    }

    if (!sl.isRegistered<BranchLocationCubit>()) {
      sl.registerFactory(() => BranchLocationCubit(sl()));
    }

    if (!sl.isRegistered<BranchesListCubit>()) {
      sl.registerFactory(() => BranchesListCubit(sl()));
    }

    if (!sl.isRegistered<CreatePackageCubit>()) {
      sl.registerFactory(() => CreatePackageCubit(sl()));
    }
  }

  // /// =============================
  // /// HOME FEATURE
  // /// =============================
  // void _initHome() {
  //   sl.registerLazySingleton(() => HomeRepository(sl()));
  //   sl.registerFactory(() => HomeCubit(sl()));
  // }
}
