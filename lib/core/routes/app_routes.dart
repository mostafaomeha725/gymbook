import 'package:chucker_flutter/chucker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gymbook/features/admin_home/presentation/screens/add_branch_four_screen.dart';
import 'package:gymbook/features/admin_home/presentation/screens/add_branch_one_screen.dart';
import 'package:gymbook/features/admin_home/presentation/screens/add_branch_three_screen.dart';
import 'package:gymbook/features/admin_home/presentation/screens/add_branch_two_screen.dart';
import 'package:gymbook/features/admin_home/presentation/screens/add_new_package_screen.dart';
import 'package:gymbook/features/admin_home/presentation/screens/manage_package_screen.dart';
import 'package:gymbook/features/auth/presentation/screens/gym_register_details_screen.dart';
import 'package:gymbook/features/auth/presentation/screens/join_us_screen.dart';
import 'package:gymbook/features/auth/presentation/screens/login_screen.dart';
import 'package:gymbook/features/auth/presentation/screens/otp_screen.dart';
import 'package:gymbook/features/auth/presentation/screens/register_bussiness_screen.dart';
import 'package:gymbook/features/auth/presentation/screens/register_customer_screen.dart';
import 'package:gymbook/core/widgets/custom_nav_bar.dart';
import 'package:gymbook/features/home/presentation/screens/edit_profile_screen.dart';
import 'package:gymbook/features/home/presentation/screens/full_image_viewer_screen.dart';
import 'package:gymbook/features/home/presentation/screens/gym_details_screen.dart';
import 'package:gymbook/features/home/presentation/screens/subscriptions_details_screen.dart';
import 'package:gymbook/features/home/presentation/screens/widgets/full_image_viewer_args.dart';
import 'package:gymbook/features/home/presentation/screens/widgets/gym_details_screen_body.dart';

import '/core/env.dart';
import 'route_observer.dart';
import 'route_paths.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

final CustomGoRouterObserver customGoRouterObserver = CustomGoRouterObserver();

GoRouter createRouter() {
  return GoRouter(
    initialLocation: Routes.addNewPackageScreen,
    navigatorKey: navigatorKey,
    debugLogDiagnostics: true,
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
        path: Routes.registerCustomerScreen,
        builder: (context, state) => const RegisterCustomerScreen(),
      ),
      GoRoute(
        path: Routes.registerBussinessScreen,
        builder: (context, state) => const RegisterBussinessScreen(),
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
        builder: (context, state) => const CustomNavBar(),
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
            opaque: false, // لضمان رؤية الخلفية
            barrierColor: Colors.black.withOpacity(0.5), // درجة التعتيم
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
                  return FadeTransition(opacity: animation, child: child);
                },
            child: FullImageViewerScreen(args: args), // مرر الـ args هنا
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
        builder: (context, state) => const AddBranchOneScreen(),
      ),
      GoRoute(
        path: Routes.addBranchTwoScreen,
        builder: (context, state) => const AddBranchTwoScreen(),
      ),
      GoRoute(
        path: Routes.addBranchThreeScreen,
        builder: (context, state) => const AddBranchThreeScreen(),
      ),
      GoRoute(
        path: Routes.addBranchFourScreen,
        builder: (context, state) => const AddBranchFourScreen(),
      ),
      GoRoute(
        path: Routes.addNewPackageScreen,
        builder: (context, state) => const AddNewPackageScreen(),
      ),
      GoRoute(
        path: Routes.managePackageScreen,
        builder: (context, state) => const ManagePackageScreen(),
      ),
    ],
  );
}
