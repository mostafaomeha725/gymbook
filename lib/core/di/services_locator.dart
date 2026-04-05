import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:gymbook/core/cache/preferences_storage.dart';
import 'package:gymbook/core/network/network_service.dart';
import 'package:gymbook/features/admin_home/data/datasources/branch_remote_datasource.dart';
import 'package:gymbook/features/admin_home/data/datasources/governorates_remote_datasource.dart';
import 'package:gymbook/features/admin_home/data/datasources/package_remote_datasource.dart';
import 'package:gymbook/features/admin_home/data/datasources/subscription_remote_datasource.dart';
import 'package:gymbook/features/admin_home/data/repositories/branch_repository_impl.dart';
import 'package:gymbook/features/admin_home/data/repositories/governorates_repository_impl.dart';
import 'package:gymbook/features/admin_home/data/repositories/package_repository_impl.dart';
import 'package:gymbook/features/admin_home/data/repositories/subscription_repository_impl.dart';
import 'package:gymbook/features/admin_home/domain/repositories/branch_repository.dart';
import 'package:gymbook/features/admin_home/domain/repositories/governorates_repository.dart';
import 'package:gymbook/features/admin_home/domain/repositories/package_repository.dart';
import 'package:gymbook/features/admin_home/domain/repositories/subscription_repository.dart';
import 'package:gymbook/features/admin_home/domain/usecases/add_member_usecase.dart';
import 'package:gymbook/features/admin_home/domain/usecases/activate_branch_images_usecase.dart';
import 'package:gymbook/features/admin_home/domain/usecases/add_subscription_usecase.dart';
import 'package:gymbook/features/admin_home/domain/usecases/cancel_subscription_usecase.dart';
import 'package:gymbook/features/admin_home/domain/usecases/freeze_subscription_usecase.dart';
import 'package:gymbook/features/admin_home/domain/usecases/get_subscription_details_usecase.dart';
import 'package:gymbook/features/admin_home/domain/usecases/get_governorates_usecase.dart';
import 'package:gymbook/features/admin_home/domain/usecases/get_branch_subscriptions_usecase.dart';
import 'package:gymbook/features/admin_home/domain/usecases/create_branch_usecase.dart';
import 'package:gymbook/features/admin_home/domain/usecases/create_package_usecase.dart';
import 'package:gymbook/features/admin_home/domain/usecases/delete_package_usecase.dart';
import 'package:gymbook/features/admin_home/domain/usecases/edit_branch_usecase.dart';
import 'package:gymbook/features/admin_home/domain/usecases/get_branch_details_usecase.dart';
import 'package:gymbook/features/admin_home/domain/usecases/get_branch_packages_usecase.dart';
import 'package:gymbook/features/admin_home/domain/usecases/get_branch_setup_details_usecase.dart';
import 'package:gymbook/features/admin_home/domain/usecases/get_branch_statistics_usecase.dart';
import 'package:gymbook/features/admin_home/domain/usecases/get_branches_usecase.dart';
import 'package:gymbook/features/admin_home/domain/usecases/update_branch_location_usecase.dart';
import 'package:gymbook/features/admin_home/domain/usecases/update_branch_status_usecase.dart';
import 'package:gymbook/features/admin_home/domain/usecases/update_package_status_usecase.dart';
import 'package:gymbook/features/admin_home/domain/usecases/update_package_usecase.dart';
import 'package:gymbook/features/admin_home/domain/usecases/update_working_hours_usecase.dart';
import 'package:gymbook/features/admin_home/domain/usecases/upload_branch_image_usecase.dart';
import 'package:gymbook/features/admin_home/domain/usecases/unfreeze_subscription_usecase.dart';
import 'package:gymbook/features/admin_home/presentation/cubits/add_member_cubit/add_member_cubit.dart';
import 'package:gymbook/features/admin_home/presentation/cubits/add_subscription_cubit/add_subscription_cubit.dart';
import 'package:gymbook/features/admin_home/presentation/cubits/branch_images_cubit/branch_images_cubit.dart';
import 'package:gymbook/features/admin_home/presentation/cubits/branch_subscriptions_list_cubit/branch_subscriptions_list_cubit.dart';
import 'package:gymbook/features/admin_home/presentation/cubits/branch_setup_cubit/branch_setup_cubit.dart';
import 'package:gymbook/features/admin_home/presentation/cubits/cancel_subscription_cubit/cancel_subscription_cubit.dart';
import 'package:gymbook/features/admin_home/presentation/cubits/freeze_subscription_cubit/freeze_subscription_cubit.dart';
import 'package:gymbook/features/admin_home/presentation/cubits/governorates_cubit/governorates_cubit.dart';
import 'package:gymbook/features/admin_home/presentation/cubits/subscription_details_cubit/subscription_details_cubit.dart';
import 'package:gymbook/features/admin_home/presentation/cubits/branch_details_cubit/branch_details_cubit.dart';
import 'package:gymbook/features/admin_home/presentation/cubits/branch_location_cubit/branch_location_cubit.dart';
import 'package:gymbook/features/admin_home/presentation/cubits/branch_packages_list_cubit/branch_packages_list_cubit.dart';
import 'package:gymbook/features/admin_home/presentation/cubits/branch_statistics_cubit/branch_statistics_cubit.dart';
import 'package:gymbook/features/admin_home/presentation/cubits/branch_working_hours_cubit/branch_working_hours_cubit.dart';
import 'package:gymbook/features/admin_home/presentation/cubits/branches_list_cubit/branches_list_cubit.dart';
import 'package:gymbook/features/admin_home/presentation/cubits/create_branch_cubit/create_branch_cubit.dart';
import 'package:gymbook/features/admin_home/presentation/cubits/create_package_cubit/create_package_cubit.dart';
import 'package:gymbook/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:gymbook/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:gymbook/features/auth/domain/repositories/auth_repository.dart';
import 'package:gymbook/features/auth/domain/usecases/login_usecase.dart';
import 'package:gymbook/features/auth/domain/usecases/login_with_google_usecase.dart';
import 'package:gymbook/features/auth/domain/usecases/resend_confirmation_email_usecase.dart';
import 'package:gymbook/features/auth/domain/usecases/reset_password_usecase.dart';
import 'package:gymbook/features/auth/domain/usecases/register_usecase.dart';
import 'package:gymbook/features/auth/domain/usecases/send_reset_password_email_usecase.dart';
import 'package:gymbook/features/auth/domain/usecases/validate_reset_password_code_usecase.dart';
import 'package:gymbook/features/auth/presentation/cubits/forget_password_cubit/forget_password_cubit.dart';
import 'package:gymbook/features/auth/presentation/cubits/login_cubit/login_cubit.dart';
import 'package:gymbook/features/auth/presentation/cubits/resend_confirmation_email_cubit/resend_confirmation_email_cubit.dart';
import 'package:gymbook/features/auth/presentation/cubits/reset_password_cubit/reset_password_cubit.dart';
import 'package:gymbook/features/auth/presentation/cubits/register_cubit/register_cubit.dart';
import 'package:gymbook/features/auth/presentation/cubits/validate_reset_password_code_cubit/validate_reset_password_code_cubit.dart';
import 'package:gymbook/features/admin_scanner_qrcode/data/datasources/admin_me_remote_datasource.dart';
import 'package:gymbook/features/admin_scanner_qrcode/data/datasources/checkin_remote_datasource.dart';
import 'package:gymbook/features/admin_scanner_qrcode/data/repositories/admin_me_repository_impl.dart';
import 'package:gymbook/features/admin_scanner_qrcode/data/repositories/checkin_repository_impl.dart';
import 'package:gymbook/features/admin_scanner_qrcode/domain/repositories/admin_me_repository.dart';
import 'package:gymbook/features/admin_scanner_qrcode/domain/repositories/checkin_repository.dart';
import 'package:gymbook/features/admin_scanner_qrcode/domain/usecases/add_checkin_usecase.dart';
import 'package:gymbook/features/admin_scanner_qrcode/domain/usecases/get_admin_my_branches_usecase.dart';
import 'package:gymbook/features/admin_scanner_qrcode/presentation/cubits/admin_my_branches_cubit/admin_my_branches_cubit.dart';
import 'package:gymbook/features/admin_scanner_qrcode/presentation/cubits/admin_qr_scanner_cubit/admin_qr_scanner_cubit.dart';
import 'package:gymbook/features/customer_home/data/datasources/nearby_branches_remote_datasource.dart';
import 'package:gymbook/features/customer_home/data/repositories/nearby_branches_repository_impl.dart';
import 'package:gymbook/features/customer_home/domain/repositories/nearby_branches_repository.dart';
import 'package:gymbook/features/customer_home/domain/usecases/get_nearby_branches_usecase.dart';
import 'package:gymbook/features/customer_home/presentation/cubits/nearby_branches_cubit/nearby_branches_cubit.dart';
import 'package:gymbook/features/customer_subscriptions/data/datasources/subscription_attendance_history_remote_datasource.dart';
import 'package:gymbook/features/customer_subscriptions/data/datasources/customer_subscription_details_remote_datasource.dart';
import 'package:gymbook/features/customer_subscriptions/data/repositories/customer_subscription_details_repository_impl.dart';
import 'package:gymbook/features/customer_subscriptions/data/repositories/subscription_attendance_history_repository_impl.dart';
import 'package:gymbook/features/customer_subscriptions/domain/repositories/customer_subscription_details_repository.dart';
import 'package:gymbook/features/customer_subscriptions/domain/repositories/subscription_attendance_history_repository.dart';
import 'package:gymbook/features/customer_subscriptions/domain/usecases/build_attendance_weeks_usecase.dart';
import 'package:gymbook/features/customer_subscriptions/domain/usecases/get_customer_subscription_details_usecase.dart';
import 'package:gymbook/features/customer_subscriptions/domain/usecases/get_subscription_attendance_history_usecase.dart';
import 'package:gymbook/features/customer_subscriptions/presentation/cubits/customer_subscription_details_cubit/customer_subscription_details_cubit.dart';
import 'package:gymbook/features/customer_subscriptions/presentation/cubits/subscription_attendance_history_cubit/subscription_attendance_history_cubit.dart';
import 'package:gymbook/features/customer_qrcode/presentation/cubits/entry_qrcode_cubit/entry_qrcode_cubit.dart';
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
    _initCustomerHome();
    _initCustomerSubscriptions();
    _initCustomerQrCode();
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
    if (!sl.isRegistered<SendResetPasswordEmailUseCase>()) {
      sl.registerLazySingleton(() => SendResetPasswordEmailUseCase(sl()));
    }
    if (!sl.isRegistered<ValidateResetPasswordCodeUseCase>()) {
      sl.registerLazySingleton(() => ValidateResetPasswordCodeUseCase(sl()));
    }
    if (!sl.isRegistered<ResendConfirmationEmailUseCase>()) {
      sl.registerLazySingleton(() => ResendConfirmationEmailUseCase(sl()));
    }
    if (!sl.isRegistered<ResetPasswordUseCase>()) {
      sl.registerLazySingleton(() => ResetPasswordUseCase(sl()));
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
    if (!sl.isRegistered<ForgetPasswordCubit>()) {
      sl.registerFactory(() => ForgetPasswordCubit(sl()));
    }
    if (!sl.isRegistered<ValidateResetPasswordCodeCubit>()) {
      sl.registerFactory(() => ValidateResetPasswordCodeCubit(sl()));
    }
    if (!sl.isRegistered<ResendConfirmationEmailCubit>()) {
      sl.registerFactory(() => ResendConfirmationEmailCubit(sl()));
    }
    if (!sl.isRegistered<ResetPasswordCubit>()) {
      sl.registerFactory(() => ResetPasswordCubit(sl()));
    }
  }

  /// =============================
  /// ADMIN FEATURE
  /// =============================
  void _initAdmin() {
    // DataSource
    if (!sl.isRegistered<AdminMeRemoteDataSource>()) {
      sl.registerLazySingleton<AdminMeRemoteDataSource>(
        () => AdminMeRemoteDataSourceImpl(sl()),
      );
    }
    if (!sl.isRegistered<BranchRemoteDataSource>()) {
      sl.registerLazySingleton<BranchRemoteDataSource>(
        () => BranchRemoteDataSourceImpl(sl()),
      );
    }
    if (!sl.isRegistered<PackageRemoteDataSource>()) {
      sl.registerLazySingleton<PackageRemoteDataSource>(
        () => PackageRemoteDataSourceImpl(sl()),
      );
    }
    if (!sl.isRegistered<GovernoratesRemoteDataSource>()) {
      sl.registerLazySingleton<GovernoratesRemoteDataSource>(
        () => GovernoratesRemoteDataSourceImpl(sl()),
      );
    }
    if (!sl.isRegistered<SubscriptionRemoteDataSource>()) {
      sl.registerLazySingleton<SubscriptionRemoteDataSource>(
        () => SubscriptionRemoteDataSourceImpl(sl()),
      );
    }
    if (!sl.isRegistered<CheckInRemoteDataSource>()) {
      sl.registerLazySingleton<CheckInRemoteDataSource>(
        () => CheckInRemoteDataSourceImpl(sl()),
      );
    }

    // Repository
    if (!sl.isRegistered<AdminMeRepository>()) {
      sl.registerLazySingleton<AdminMeRepository>(
        () => AdminMeRepositoryImpl(sl()),
      );
    }
    if (!sl.isRegistered<BranchRepository>()) {
      sl.registerLazySingleton<BranchRepository>(
        () => BranchRepositoryImpl(sl()),
      );
    }
    if (!sl.isRegistered<PackageRepository>()) {
      sl.registerLazySingleton<PackageRepository>(
        () => PackageRepositoryImpl(sl()),
      );
    }
    if (!sl.isRegistered<GovernoratesRepository>()) {
      sl.registerLazySingleton<GovernoratesRepository>(
        () => GovernoratesRepositoryImpl(sl()),
      );
    }
    if (!sl.isRegistered<SubscriptionRepository>()) {
      sl.registerLazySingleton<SubscriptionRepository>(
        () => SubscriptionRepositoryImpl(sl()),
      );
    }
    if (!sl.isRegistered<CheckInRepository>()) {
      sl.registerLazySingleton<CheckInRepository>(
        () => CheckInRepositoryImpl(sl()),
      );
    }

    // Use Cases
    if (!sl.isRegistered<GetAdminMyBranchesUseCase>()) {
      sl.registerLazySingleton(() => GetAdminMyBranchesUseCase(sl()));
    }
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
    if (!sl.isRegistered<GetBranchSetupDetailsUseCase>()) {
      sl.registerLazySingleton(() => GetBranchSetupDetailsUseCase(sl()));
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
    if (!sl.isRegistered<ActivateBranchImagesUseCase>()) {
      sl.registerLazySingleton(() => ActivateBranchImagesUseCase(sl()));
    }
    if (!sl.isRegistered<GetBranchStatisticsUseCase>()) {
      sl.registerLazySingleton(() => GetBranchStatisticsUseCase(sl()));
    }
    if (!sl.isRegistered<AddSubscriptionUseCase>()) {
      sl.registerLazySingleton(() => AddSubscriptionUseCase(sl()));
    }
    if (!sl.isRegistered<AddMemberUseCase>()) {
      sl.registerLazySingleton(() => AddMemberUseCase(sl()));
    }
    if (!sl.isRegistered<GetBranchSubscriptionsUseCase>()) {
      sl.registerLazySingleton(() => GetBranchSubscriptionsUseCase(sl()));
    }
    if (!sl.isRegistered<GetGovernoratesUseCase>()) {
      sl.registerLazySingleton(() => GetGovernoratesUseCase(sl()));
    }
    if (!sl.isRegistered<AddCheckInUseCase>()) {
      sl.registerLazySingleton(() => AddCheckInUseCase(sl()));
    }

    // Cubits
    if (!sl.isRegistered<AdminMyBranchesCubit>()) {
      sl.registerFactory(() => AdminMyBranchesCubit(sl()));
    }
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
    if (!sl.isRegistered<BranchSetupCubit>()) {
      sl.registerFactory(() => BranchSetupCubit(sl()));
    }
    if (!sl.isRegistered<BranchImagesCubit>()) {
      sl.registerFactory(
        () => BranchImagesCubit(
          uploadBranchImageUseCase: sl(),
          activateBranchImagesUseCase: sl(),
        ),
      );
    }
    if (!sl.isRegistered<BranchStatisticsCubit>()) {
      sl.registerFactory(() => BranchStatisticsCubit(sl()));
    }
    if (!sl.isRegistered<AddSubscriptionCubit>()) {
      sl.registerFactory(() => AddSubscriptionCubit(sl()));
    }
    if (!sl.isRegistered<AddMemberCubit>()) {
      sl.registerFactory(() => AddMemberCubit(sl()));
    }
    if (!sl.isRegistered<BranchSubscriptionsListCubit>()) {
      sl.registerFactory(() => BranchSubscriptionsListCubit(sl()));
    }
    if (!sl.isRegistered<CancelSubscriptionUseCase>()) {
      sl.registerLazySingleton(() => CancelSubscriptionUseCase(sl()));
    }
    if (!sl.isRegistered<FreezeSubscriptionUseCase>()) {
      sl.registerLazySingleton(() => FreezeSubscriptionUseCase(sl()));
    }
    if (!sl.isRegistered<UnfreezeSubscriptionUseCase>()) {
      sl.registerLazySingleton(() => UnfreezeSubscriptionUseCase(sl()));
    }
    if (!sl.isRegistered<CancelSubscriptionCubit>()) {
      sl.registerFactory(() => CancelSubscriptionCubit(sl()));
    }
    if (!sl.isRegistered<FreezeSubscriptionCubit>()) {
      sl.registerFactory(
        () => FreezeSubscriptionCubit(
          freezeSubscriptionUseCase: sl(),
          unfreezeSubscriptionUseCase: sl(),
        ),
      );
    }
    if (!sl.isRegistered<GetSubscriptionDetailsUseCase>()) {
      sl.registerLazySingleton(() => GetSubscriptionDetailsUseCase(sl()));
    }
    if (!sl.isRegistered<SubscriptionDetailsCubit>()) {
      sl.registerFactory(() => SubscriptionDetailsCubit(sl()));
    }
    if (!sl.isRegistered<GovernoratesCubit>()) {
      sl.registerFactory(() => GovernoratesCubit(sl()));
    }
    if (!sl.isRegistered<AdminQrScannerCubit>()) {
      sl.registerFactory(() => AdminQrScannerCubit(sl()));
    }
  }

  /// =============================
  /// CUSTOMER HOME FEATURE
  /// =============================
  void _initCustomerHome() {
    if (!sl.isRegistered<NearbyBranchesRemoteDataSource>()) {
      sl.registerLazySingleton<NearbyBranchesRemoteDataSource>(
        () => NearbyBranchesRemoteDataSourceImpl(sl()),
      );
    }

    if (!sl.isRegistered<NearbyBranchesRepository>()) {
      sl.registerLazySingleton<NearbyBranchesRepository>(
        () => NearbyBranchesRepositoryImpl(sl()),
      );
    }

    if (!sl.isRegistered<GetNearbyBranchesUseCase>()) {
      sl.registerLazySingleton(() => GetNearbyBranchesUseCase(sl()));
    }

    if (!sl.isRegistered<NearbyBranchesCubit>()) {
      sl.registerFactory(() => NearbyBranchesCubit(sl()));
    }
  }

  void _initCustomerSubscriptions() {
    if (!sl.isRegistered<CustomerSubscriptionDetailsRemoteDataSource>()) {
      sl.registerLazySingleton<CustomerSubscriptionDetailsRemoteDataSource>(
        () => CustomerSubscriptionDetailsRemoteDataSourceImpl(sl()),
      );
    }

    if (!sl.isRegistered<CustomerSubscriptionDetailsRepository>()) {
      sl.registerLazySingleton<CustomerSubscriptionDetailsRepository>(
        () => CustomerSubscriptionDetailsRepositoryImpl(sl()),
      );
    }

    if (!sl.isRegistered<GetCustomerSubscriptionDetailsUseCase>()) {
      sl.registerLazySingleton(
        () => GetCustomerSubscriptionDetailsUseCase(sl()),
      );
    }

    if (!sl.isRegistered<CustomerSubscriptionDetailsCubit>()) {
      sl.registerFactory(() => CustomerSubscriptionDetailsCubit(sl()));
    }

    if (!sl.isRegistered<SubscriptionAttendanceHistoryRemoteDataSource>()) {
      sl.registerLazySingleton<SubscriptionAttendanceHistoryRemoteDataSource>(
        () => SubscriptionAttendanceHistoryRemoteDataSourceImpl(sl()),
      );
    }

    if (!sl.isRegistered<SubscriptionAttendanceHistoryRepository>()) {
      sl.registerLazySingleton<SubscriptionAttendanceHistoryRepository>(
        () => SubscriptionAttendanceHistoryRepositoryImpl(sl()),
      );
    }

    if (!sl.isRegistered<GetSubscriptionAttendanceHistoryUseCase>()) {
      sl.registerLazySingleton(
        () => GetSubscriptionAttendanceHistoryUseCase(sl()),
      );
    }

    if (!sl.isRegistered<BuildAttendanceWeeksUseCase>()) {
      sl.registerLazySingleton(() => const BuildAttendanceWeeksUseCase());
    }

    if (!sl.isRegistered<SubscriptionAttendanceHistoryCubit>()) {
      sl.registerFactory(() => SubscriptionAttendanceHistoryCubit(sl(), sl()));
    }
  }

  void _initCustomerQrCode() {
    if (!sl.isRegistered<EntryQrcodeCubit>()) {
      sl.registerFactory(() => EntryQrcodeCubit(preferencesStorage: sl()));
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
