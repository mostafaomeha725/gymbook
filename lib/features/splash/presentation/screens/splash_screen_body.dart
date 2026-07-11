import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:gymbook/core/constants/app_assets.dart';
import 'package:gymbook/core/enums/app_enums.dart';
import 'package:gymbook/core/routes/route_paths.dart';
import 'package:gymbook/core/widgets/app_asset.dart';
import 'package:gymbook/core/cache/preferences_storage.dart';
import 'package:gymbook/core/di/services_locator.dart';

class SplashScreenBody extends StatefulWidget {
  const SplashScreenBody({super.key});

  @override
  State<SplashScreenBody> createState() => _SplashScreenBodyState();
}

class _SplashScreenBodyState extends State<SplashScreenBody>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _initAnimation();
    _navigateToNextScreen();
  }

  void _initAnimation() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );

    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutBack),
    );

    _animationController.forward();
  }

  void _navigateToNextScreen() {
    Future.delayed(const Duration(milliseconds: 2500), () {
      if (mounted) {
        final storage = sl<PreferencesStorage>();
        final hasSeenOnBoarding = storage.getBoolean(
          key: PreferencesKeys.hasSeenOnBoarding,
        );
        final token = storage.getUserToken();

        if (token != null && token.isNotEmpty) {
          final isEmailConfirmed = storage.isUserEmailConfirmed();
          if (isEmailConfirmed) {
            context.go(Routes.mainNavigationScreen);
          } else {
            context.go(Routes.otpScreen);
          }
        } else {
          if (!hasSeenOnBoarding) {
            // Mark as seen immediately so re-opening the app won't show it again
            storage.putBoolean(
              key: PreferencesKeys.hasSeenOnBoarding,
              value: true,
            );
            context.go(Routes.onBoardingScreen);
          } else {
            context.go(Routes.loginScreen);
          }
        }
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: AppAsset(assetName: Assets.logo, width: 260.w),
        ),
      ),
    );
  }
}
