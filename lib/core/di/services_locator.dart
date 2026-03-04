import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:gymbook/core/cache/preferences_storage.dart';
import 'package:gymbook/core/network/network_service.dart';
import 'package:gymbook/features/admin_home/data/datasources/admin_branch_remote_datasource.dart';
import 'package:gymbook/features/admin_home/data/repositories/admin_branch_repository_impl.dart';
import 'package:gymbook/features/admin_home/domain/repositories/admin_branch_repository.dart';
import 'package:gymbook/features/admin_home/domain/usecases/create_branch_usecase.dart';
import 'package:gymbook/features/admin_home/domain/usecases/create_package_usecase.dart';
import 'package:gymbook/features/admin_home/domain/usecases/delete_package_usecase.dart';
import 'package:gymbook/features/admin_home/domain/usecases/edit_branch_usecase.dart';
import 'package:gymbook/features/admin_home/domain/usecases/get_branch_details_usecase.dart';
import 'package:gymbook/features/admin_home/domain/usecases/get_branch_packages_usecase.dart';
import 'package:gymbook/features/admin_home/domain/usecases/get_branches_usecase.dart';
import 'package:gymbook/features/admin_home/domain/usecases/update_branch_location_usecase.dart';
import 'package:gymbook/features/admin_home/domain/usecases/update_branch_status_usecase.dart';
import 'package:gymbook/features/admin_home/domain/usecases/update_package_status_usecase.dart';
import 'package:gymbook/features/admin_home/domain/usecases/update_package_usecase.dart';
import 'package:gymbook/features/admin_home/domain/usecases/update_working_hours_usecase.dart';
import 'package:gymbook/features/admin_home/domain/usecases/upload_branch_image_usecase.dart';
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
    // DataSource
    if (!sl.isRegistered<AdminBranchRemoteDataSource>()) {
      sl.registerLazySingleton<AdminBranchRemoteDataSource>(
        () => AdminBranchRemoteDataSourceImpl(sl()),
      );
    }

    // Repository
    if (!sl.isRegistered<AdminBranchRepository>()) {
      sl.registerLazySingleton<AdminBranchRepository>(
        () => AdminBranchRepositoryImpl(sl()),
      );
    }

    // Use Cases
    if (!sl.isRegistered<CreateBranchUseCase>()) {
      sl.registerLazySingleton(() => CreateBranchUseCase(sl()));
    }
    if (!sl.isRegistered<EditBranchUseCase>()) {
      sl.registerLazySingleton(() => EditBranchUseCase(sl()));
    }
    if (!sl.isRegistered<GetBranchesUseCase>()) {
      sl.registerLazySingleton(() => GetBranchesUseCase(sl()));
    }
    if (!sl.isRegistered<GetBranchDetailsUseCase>()) {
      sl.registerLazySingleton(() => GetBranchDetailsUseCase(sl()));
    }
    if (!sl.isRegistered<UpdateWorkingHoursUseCase>()) {
      sl.registerLazySingleton(() => UpdateWorkingHoursUseCase(sl()));
    }
    if (!sl.isRegistered<UpdateBranchLocationUseCase>()) {
      sl.registerLazySingleton(() => UpdateBranchLocationUseCase(sl()));
    }
    if (!sl.isRegistered<UpdateBranchStatusUseCase>()) {
      sl.registerLazySingleton(() => UpdateBranchStatusUseCase(sl()));
    }
    if (!sl.isRegistered<CreatePackageUseCase>()) {
      sl.registerLazySingleton(() => CreatePackageUseCase(sl()));
    }
    if (!sl.isRegistered<UpdatePackageUseCase>()) {
      sl.registerLazySingleton(() => UpdatePackageUseCase(sl()));
    }
    if (!sl.isRegistered<GetBranchPackagesUseCase>()) {
      sl.registerLazySingleton(() => GetBranchPackagesUseCase(sl()));
    }
    if (!sl.isRegistered<UpdatePackageStatusUseCase>()) {
      sl.registerLazySingleton(() => UpdatePackageStatusUseCase(sl()));
    }
    if (!sl.isRegistered<DeletePackageUseCase>()) {
      sl.registerLazySingleton(() => DeletePackageUseCase(sl()));
    }
    if (!sl.isRegistered<UploadBranchImageUseCase>()) {
      sl.registerLazySingleton(() => UploadBranchImageUseCase(sl()));
    }

    // Cubits
    if (!sl.isRegistered<CreateBranchCubit>()) {
      sl.registerFactory(
        () => CreateBranchCubit(
          createBranchUseCase: sl(),
          editBranchUseCase: sl(),
        ),
      );
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
      sl.registerFactory(
        () => CreatePackageCubit(
          createPackageUseCase: sl(),
          updatePackageUseCase: sl(),
          updatePackageStatusUseCase: sl(),
          deletePackageUseCase: sl(),
        ),
      );
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
