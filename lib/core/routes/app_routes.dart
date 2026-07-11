import 'package:chucker_flutter/chucker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gymbook/core/cache/preferences_storage.dart';
import 'package:gymbook/core/enums/app_enums.dart';
import 'package:gymbook/core/di/services_locator.dart';
import 'package:gymbook/features/admin/admin_home/data/models/branch_list_model.dart';
import 'package:gymbook/features/admin/admin_home/domain/entities/branch_entity.dart';
import 'package:gymbook/features/admin/admin_home/data/models/package_model.dart';
import 'package:gymbook/features/admin/admin_home/presentation/screens/add_branch_four_screen.dart';
import 'package:gymbook/features/admin/admin_home/presentation/screens/add_branch_one_screen.dart';
import 'package:gymbook/features/admin/admin_home/presentation/screens/add_branch_three_screen.dart';
import 'package:gymbook/features/admin/admin_home/presentation/screens/add_branch_two_screen.dart';
import 'package:gymbook/features/admin/admin_home/presentation/screens/add_new_package_screen.dart';
import 'package:gymbook/features/admin/admin_home/presentation/screens/admin_add_subscription_screen.dart';
import 'package:gymbook/features/admin/admin_home/presentation/screens/admin_branch_screen.dart';
import 'package:gymbook/features/admin/admin_home/presentation/screens/admin_manage_subscriptions_screen.dart';
import 'package:gymbook/features/admin/admin_home/presentation/screens/admin_branch_reviews_screen.dart';
import 'package:gymbook/features/admin/admin_home/presentation/cubits/branch_reviews/branch_reviews_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gymbook/features/admin/admin_home/presentation/screens/admin_subscription_details_screen.dart';
import 'package:gymbook/features/admin/admin_home/presentation/screens/admin_employees_screen.dart';
import 'package:gymbook/features/admin/admin_home/presentation/screens/add_edit_employee_screen.dart';
import 'package:gymbook/features/admin/admin_home/presentation/models/add_edit_employee_screen_args.dart';
import 'package:gymbook/features/admin/admin_home/presentation/screens/edit_branch_details_screen.dart';
import 'package:gymbook/features/admin/admin_home/presentation/screens/manage_package_screen.dart';
import 'package:gymbook/features/auth/presentation/screens/join_us_screen.dart';
import 'package:gymbook/features/auth/presentation/screens/login_screen.dart';
import 'package:gymbook/features/auth/presentation/screens/otp_screen.dart';
import 'package:gymbook/features/auth/presentation/screens/register_screen.dart';
import 'package:gymbook/features/auth/presentation/screens/forget_password_screen.dart';
import 'package:gymbook/features/auth/presentation/screens/reset_password_screen.dart';
import 'package:gymbook/core/widgets/custom_nav_bar.dart';
import 'package:gymbook/features/customer/customer_subscriptions/presentation/screens/subscriptions_details_screen.dart';
import 'package:gymbook/features/customer/customer_home/presentation/screens/full_image_viewer_screen.dart';
import 'package:gymbook/features/customer/customer_home/presentation/screens/gym_details_screen.dart';
import 'package:gymbook/features/customer/customer_home/presentation/widgets/full_image_viewer_args.dart';
import 'package:gymbook/features/customer/customer_home/presentation/widgets/gym_details_screen_body.dart';
import 'package:gymbook/features/notifications/presentation/screens/notifications_screen.dart';
import 'package:gymbook/features/on_boarding/on_boarding_one_view.dart';
import 'package:gymbook/features/splash/presentation/screens/splash_screen.dart';

import 'package:gymbook/features/settings/presentation/screens/change_password_screen.dart';

import 'package:gymbook/features/settings/presentation/screens/edit_profile_screen.dart';
import 'package:gymbook/features/settings/presentation/screens/privacy_policy_screen.dart';
import 'package:gymbook/features/settings/presentation/screens/terms_of_use_screen.dart';

import '/core/env.dart';
import 'route_observer.dart';
import 'route_paths.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

final CustomGoRouterObserver customGoRouterObserver = CustomGoRouterObserver();

String _getInitialLocation() {
  return Routes.splashScreen;
}

GoRouter createRouter() {
  return GoRouter(
    initialLocation: _getInitialLocation(),
    navigatorKey: navigatorKey,
    debugLogDiagnostics: true,
    redirect: (context, state) {
      final storage = sl<PreferencesStorage>();
      final token = storage.getUserToken();
      final isLoggedIn = token != null && token.isNotEmpty;
      final isEmailConfirmed = storage.isUserEmailConfirmed();

      if (isLoggedIn && !isEmailConfirmed) {
        if (state.matchedLocation != Routes.otpScreen &&
            state.matchedLocation != Routes.loginScreen) {
          return Routes.otpScreen;
        }
      }

      if (isLoggedIn &&
          isEmailConfirmed &&
          (state.matchedLocation == Routes.loginScreen ||
              state.matchedLocation == Routes.forgetPasswordScreen ||
              state.matchedLocation == Routes.resetPasswordScreen ||
              state.matchedLocation == Routes.registerScreen ||
              state.matchedLocation == Routes.otpScreen ||
              state.matchedLocation == Routes.onBoardingScreen ||
              state.matchedLocation == Routes.joinusScreen)) {
        return Routes.mainNavigationScreen;
      }

      if (!isLoggedIn &&
          state.matchedLocation != Routes.splashScreen &&
          state.matchedLocation != Routes.onBoardingScreen &&
          state.matchedLocation != Routes.loginScreen &&
          state.matchedLocation != Routes.forgetPasswordScreen &&
          state.matchedLocation != Routes.resetPasswordScreen &&
          state.matchedLocation != Routes.registerScreen &&
          state.matchedLocation != Routes.joinusScreen &&
          state.matchedLocation != Routes.otpScreen) {
        return Routes.loginScreen;
      }

      return null;
    },
    observers: [
      if (isDevEnviroment()) ChuckerFlutter.navigatorObserver,
      // customGoRouterObserver,
    ],
    routes: [
      GoRoute(
        path: Routes.splashScreen,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: Routes.onBoardingScreen,
        builder: (context, state) => const OnBoardingOneView(),
      ),
      GoRoute(
        path: Routes.joinusScreen,
        builder: (context, state) => const JoinUsScreen(),
      ),
      GoRoute(
        path: Routes.loginScreen,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: Routes.forgetPasswordScreen,
        builder: (context, state) => const ForgetPasswordScreen(),
      ),
      GoRoute(
        path: Routes.resetPasswordScreen,
        builder: (context, state) {
          final args = state.extra is ResetPasswordScreenArgs
              ? state.extra as ResetPasswordScreenArgs
              : const ResetPasswordScreenArgs(email: '', code: '');

          return ResetPasswordScreen(args: args);
        },
      ),
      GoRoute(
        path: Routes.registerScreen,
        builder: (context, state) {
          final type = state.extra as RegisterType;
          return RegisterScreen(type: type);
        },
      ),

      GoRoute(
        path: Routes.otpScreen,
        builder: (context, state) {
          final extra = state.extra;

          final storage = sl<PreferencesStorage>();
          final savedEmail = storage.getString(key: PreferencesKeys.email);
          final userType = storage.getUserType() ?? 4;
          final fallbackSource = userType == 2
              ? OtpSource.business
              : OtpSource.customer;

          final OtpScreenArgs args = extra is OtpScreenArgs
              ? extra
              : OtpScreenArgs(
                  source: fallbackSource,
                  purpose: OtpPurpose.confirmEmail,
                  email: savedEmail,
                );

          return OtpScreen(
            totalSteps: args.purpose == OtpPurpose.resetPassword ? 3 : 2,
            source: args.source,
            purpose: args.purpose,
            email: args.email,
          );
        },
      ),

      GoRoute(
        path: Routes.mainNavigationScreen,
        builder: (context, state) {
          return const CustomNavBar();
        },
      ),
      GoRoute(
        path: Routes.gymDetailsScreen,
        builder: (context, state) {
          final args = state.extra as GymDetailsArgs;
          return GymDetailsScreen(args: args);
        },
      ),

      GoRoute(
        path: Routes.fullImageViewerScreen,
        pageBuilder: (context, state) {
          final args = state.extra as FullImageViewerArgs;
          return CustomTransitionPage(
            opaque: false,
            barrierColor: Colors.black.withOpacity(0.5),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
                  return FadeTransition(opacity: animation, child: child);
                },
            child: FullImageViewerScreen(args: args),
          );
        },
      ),
      GoRoute(
        path: Routes.editProfileScreen,
        builder: (context, state) => const EditProfileScreen(),
      ),
      GoRoute(
        path: Routes.changePasswordScreen,
        builder: (context, state) => const ChangePasswordScreen(),
      ),
      GoRoute(
        path: Routes.subscriptionsDetailsScreen,
        builder: (context, state) {
          final args =
              state.extra as CustomerSubscriptionDetailsArgs? ??
              const CustomerSubscriptionDetailsArgs(
                subscriptionId: 0,
                status: 1,
              );
          return SubscriptionsDetailsScreen(args: args);
        },
      ),
      GoRoute(
        path: Routes.notificationsScreen,
        builder: (context, state) => const NotificationsScreen(),
      ),
      GoRoute(
        path: Routes.addBranchOneScreen,
        builder: (context, state) {
          final args = state.extra as BranchScreenArgs?;
          return AddBranchOneScreen(args: args);
        },
      ),
      GoRoute(
        path: Routes.addBranchTwoScreen,
        builder: (context, state) {
          final args = state.extra as BranchScreenArgs?;
          final branchId =
              args?.branchId ??
              (int.tryParse(state.uri.queryParameters['branchId'] ?? '') ?? 0);
          return AddBranchTwoScreen(branchId: branchId, args: args);
        },
      ),
      GoRoute(
        path: Routes.addBranchThreeScreen,
        builder: (context, state) {
          final args = state.extra as BranchScreenArgs?;
          final branchId =
              args?.branchId ??
              (int.tryParse(state.uri.queryParameters['branchId'] ?? '') ?? 0);
          return AddBranchThreeScreen(
            branchId: branchId,
            isEditMode: args?.isEditMode ?? false,
          );
        },
      ),
      GoRoute(
        path: Routes.addBranchFourScreen,
        builder: (context, state) {
          final args = state.extra as BranchScreenArgs?;
          final branchId =
              args?.branchId ??
              (int.tryParse(state.uri.queryParameters['branchId'] ?? '') ?? 0);
          final isEditMode =
              args?.isEditMode ??
              (state.uri.queryParameters['isEditMode']?.toLowerCase() ==
                  'true');
          final imageId =
              args?.branch?.logoImageId ??
              int.tryParse(state.uri.queryParameters['imageId'] ?? '');
          final logoUrl =
              args?.branch?.logo ?? state.uri.queryParameters['logoUrl'];
          return AddBranchFourScreen(
            branchId: branchId,
            isEditMode: isEditMode,
            imageId: imageId,
            logoUrl: logoUrl,
          );
        },
      ),
      GoRoute(
        path: Routes.addNewPackageScreen,
        builder: (context, state) {
          final args = state.extra as PackageScreenArgs;
          return AddNewPackageScreen(args: args);
        },
      ),
      GoRoute(
        path: Routes.managePackageScreen,
        builder: (context, state) {
          final branchId = state.extra as int;
          return ManagePackageScreen(branchId: branchId);
        },
      ),
      GoRoute(
        path: Routes.adminManageSubscriptionsScreen,
        builder: (context, state) {
          final branchId = state.extra as int? ?? 0;
          return AdminManageSubscriptionsScreen(branchId: branchId);
        },
      ),
      GoRoute(
        path: Routes.adminBranchReviewsScreen,
        builder: (context, state) {
          final extra = state.extra;
          int branchId = 0;
          String? branchName;

          if (extra is int) {
            branchId = extra;
          } else if (extra is Map<String, dynamic>) {
            branchId = extra['branchId'] as int? ?? 0;
            branchName = extra['branchName'] as String?;
          }

          return BlocProvider(
            create: (context) => BranchReviewsCubit(sl()),
            child: AdminBranchReviewsScreen(
              branchId: branchId,
              branchName: branchName,
            ),
          );
        },
      ),
      GoRoute(
        path: Routes.adminSubscriptionDetailsScreen,
        builder: (context, state) {
          final subscriptionId = state.extra as int? ?? 0;
          return AdminSubscriptionDetailsScreen(subscriptionId: subscriptionId);
        },
      ),
      GoRoute(
        path: Routes.adminAddSubscriptionScreen,
        builder: (context, state) {
          final branchId = state.extra as int? ?? 0;
          return AdminAddSubscriptionScreen(branchId: branchId);
        },
      ),
      GoRoute(
        path: Routes.adminBranchScreen,
        builder: (context, state) {
          final branch = state.extra as BranchEntity?;
          if (branch == null) return const SizedBox.shrink();
          return AdminBranchScreen(branch: branch);
        },
      ),
      GoRoute(
        path: Routes.adminEmployeesScreen,
        builder: (context, state) {
          final branchId = state.extra as int?;
          if (branchId == null) return const SizedBox.shrink();
          return AdminEmployeesScreen(branchId: branchId);
        },
      ),
      GoRoute(
        path: Routes.addEditEmployeeScreen,
        builder: (context, state) {
          final args = state.extra as AddEditEmployeeScreenArgs?;
          if (args == null) return const SizedBox.shrink();
          return AddEditEmployeeScreen(args: args);
        },
      ),
      GoRoute(
        path: Routes.editBranchDetailsScreen,
        builder: (context, state) {
          final branch = state.extra as BranchEntity?;
          if (branch == null) return const SizedBox.shrink();
          return EditBranchDetailsScreen(branch: branch);
        },
      ),
      GoRoute(
        path: Routes.privacyPolicyScreen,
        builder: (context, state) => const PrivacyPolicyScreen(),
      ),
      GoRoute(
        path: Routes.termsOfUseScreen,
        builder: (context, state) => const TermsOfUseScreen(),
      ),
    ],
  );
}
