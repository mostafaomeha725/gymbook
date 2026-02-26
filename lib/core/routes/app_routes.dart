import 'package:chucker_flutter/chucker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gymbook/core/cache/preferences_storage.dart';
import 'package:gymbook/core/di/services_locator.dart';
import 'package:gymbook/features/admin_home/data/models/branch_list_model.dart';
import 'package:gymbook/features/admin_home/presentation/screens/add_branch_four_screen.dart';
import 'package:gymbook/features/admin_home/presentation/screens/add_branch_one_screen.dart';
import 'package:gymbook/features/admin_home/presentation/screens/add_branch_three_screen.dart';
import 'package:gymbook/features/admin_home/presentation/screens/add_branch_two_screen.dart';
import 'package:gymbook/features/admin_home/presentation/screens/add_new_package_screen.dart';
import 'package:gymbook/features/admin_home/presentation/screens/admin_add_subscription_screen.dart';
import 'package:gymbook/features/admin_home/presentation/screens/admin_branch_screen.dart';
import 'package:gymbook/features/admin_home/presentation/screens/admin_manage_subscriptions_screen.dart';
import 'package:gymbook/features/admin_home/presentation/screens/admin_subscription_details_screen.dart';
import 'package:gymbook/features/admin_home/presentation/screens/edit_branch_details_screen.dart';
import 'package:gymbook/features/admin_home/presentation/screens/manage_package_screen.dart';
import 'package:gymbook/features/auth/presentation/screens/gym_register_details_screen.dart';
import 'package:gymbook/features/auth/presentation/screens/join_us_screen.dart';
import 'package:gymbook/features/auth/presentation/screens/login_screen.dart';
import 'package:gymbook/features/auth/presentation/screens/otp_screen.dart';
import 'package:gymbook/features/auth/presentation/screens/register_screen.dart';
import 'package:gymbook/core/widgets/custom_nav_bar.dart';
import 'package:gymbook/features/customer_subscriptions/presentation/screens/subscriptions_details_screen.dart';
import 'package:gymbook/features/home/presentation/screens/full_image_viewer_screen.dart';
import 'package:gymbook/features/home/presentation/screens/gym_details_screen.dart';
import 'package:gymbook/features/home/presentation/widgets/full_image_viewer_args.dart';
import 'package:gymbook/features/home/presentation/widgets/gym_details_screen_body.dart';

import 'package:gymbook/features/settings/presentation/screens/edit_profile_screen.dart';

import '/core/env.dart';
import 'route_observer.dart';
import 'route_paths.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

final CustomGoRouterObserver customGoRouterObserver = CustomGoRouterObserver();

String _getInitialLocation() {
  final storage = sl<PreferencesStorage>();
  final token = storage.getUserToken();
  return token != null && token.isNotEmpty
      ? Routes.mainNavigationScreen
      // ? Routes.editBranchDetailsScreen
      : Routes.loginScreen;
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

      if (isLoggedIn &&
          (state.matchedLocation == Routes.loginScreen ||
              state.matchedLocation == Routes.registerScreen ||
              state.matchedLocation == Routes.joinusScreen)) {
        return Routes.mainNavigationScreen;
      }

      if (!isLoggedIn &&
          state.matchedLocation != Routes.loginScreen &&
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
        path: Routes.joinusScreen,
        builder: (context, state) => const JoinUsScreen(),
      ),
      GoRoute(
        path: Routes.loginScreen,
        builder: (context, state) => const LoginScreen(),
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
          final source = state.extra as OtpSource;

          return OtpScreen(
            totalSteps: source == OtpSource.customer ? 2 : 3,
            source: source,
          );
        },
      ),

      GoRoute(
        path: Routes.gymRegisterDetailesScreen,
        builder: (context, state) => const GymRegisterDetailsScreen(),
      ),
      GoRoute(
        path: Routes.mainNavigationScreen,
        builder: (context, state) {
          final storage = sl<PreferencesStorage>();
          final isAdmin = (state.extra as bool?) ?? storage.isUserAdmin();
          return CustomNavBar(isAdmin: isAdmin);
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
        path: Routes.subscriptionsDetailsScreen,
        builder: (context, state) => const SubscriptionsDetailsScreen(),
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
          final branchId =
              int.tryParse(state.uri.queryParameters['branchId'] ?? '') ?? 0;
          final isEditMode =
              state.uri.queryParameters['isEditMode']?.toLowerCase() == 'true';
          final imageId = int.tryParse(
            state.uri.queryParameters['imageId'] ?? '',
          );
          return AddBranchFourScreen(
            branchId: branchId,
            isEditMode: isEditMode,
            imageId: imageId,
          );
        },
      ),
      GoRoute(
        path: Routes.addNewPackageScreen,
        builder: (context, state) {
          final branchId = state.extra as int;
          return AddNewPackageScreen(branchId: branchId);
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
        builder: (context, state) => const AdminManageSubscriptionsScreen(),
      ),
      GoRoute(
        path: Routes.adminSubscriptionDetailsScreen,
        builder: (context, state) => const AdminSubscriptionDetailsScreen(),
      ),
      GoRoute(
        path: Routes.adminAddSubscriptionScreen,
        builder: (context, state) => const AdminAddSubscriptionScreen(),
      ),
      GoRoute(
        path: Routes.adminBranchScreen,
        builder: (context, state) {
          final branch = state.extra as BranchItem?;
          if (branch == null) return const SizedBox.shrink();
          return AdminBranchScreen(branch: branch);
        },
      ),
      GoRoute(
        path: Routes.editBranchDetailsScreen,
        builder: (context, state) {
          final branch = state.extra as BranchItem?;
          if (branch == null) return const SizedBox.shrink();
          return EditBranchDetailsScreen(branch: branch);
        },
      ),
    ],
  );
}
