import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:gymbook/core/cache/preferences_storage.dart';
import 'package:gymbook/core/network/network_service.dart';
import 'package:gymbook/features/admin_home/data/repositories/admin_branch_repository.dart';
import 'package:gymbook/features/admin_home/presentation/cubits/branch_details_cubit/branch_details_cubit.dart';
import 'package:gymbook/features/admin_home/presentation/cubits/branch_location_cubit/branch_location_cubit.dart';
import 'package:gymbook/features/admin_home/presentation/cubits/branch_packages_list_cubit/branch_packages_list_cubit.dart';
import 'package:gymbook/features/admin_home/presentation/cubits/branch_working_hours_cubit/branch_working_hours_cubit.dart';
import 'package:gymbook/features/admin_home/presentation/cubits/branches_list_cubit/branches_list_cubit.dart';
import 'package:gymbook/features/admin_home/presentation/cubits/create_branch_cubit/create_branch_cubit.dart';
import 'package:gymbook/features/admin_home/presentation/cubits/create_package_cubit/create_package_cubit.dart';
import 'package:gymbook/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:gymbook/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:gymbook/features/auth/domain/repositories/auth_repository.dart';
import 'package:gymbook/features/auth/domain/usecases/login_usecase.dart';
import 'package:gymbook/features/auth/domain/usecases/login_with_google_usecase.dart';
import 'package:gymbook/features/auth/domain/usecases/register_usecase.dart';
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
    // DataSource
    if (!sl.isRegistered<AuthRemoteDataSource>()) {
      sl.registerLazySingleton<AuthRemoteDataSource>(
        () => AuthRemoteDataSourceImpl(sl()),
      );
    }

    // Repository
    if (!sl.isRegistered<AuthRepository>()) {
      sl.registerLazySingleton<AuthRepository>(
        () => AuthRepositoryImpl(
          remoteDataSource: sl(),
          storage: sl(),
          networkService: sl(),
        ),
      );
    }

    // Use Cases
    if (!sl.isRegistered<LoginUseCase>()) {
      sl.registerLazySingleton(() => LoginUseCase(sl()));
    }
    if (!sl.isRegistered<LoginWithGoogleUseCase>()) {
      sl.registerLazySingleton(() => LoginWithGoogleUseCase(sl()));
    }
    if (!sl.isRegistered<RegisterUseCase>()) {
      sl.registerLazySingleton(() => RegisterUseCase(sl()));
    }

    // Cubits
    if (!sl.isRegistered<LoginCubit>()) {
      sl.registerFactory(
        () => LoginCubit(loginUseCase: sl(), loginWithGoogleUseCase: sl()),
      );
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

    if (!sl.isRegistered<BranchPackagesListCubit>()) {
      sl.registerFactory(() => BranchPackagesListCubit(sl()));
    }

    if (!sl.isRegistered<BranchDetailsCubit>()) {
      sl.registerFactory(() => BranchDetailsCubit(sl()));
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
