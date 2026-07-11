import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:gymbook/core/cache/preferences_storage.dart';
import 'package:gymbook/core/enums/app_enums.dart';
import 'package:gymbook/core/di/services_locator.dart';
import 'package:gymbook/core/constants/app_assets.dart';
import 'package:gymbook/core/routes/route_paths.dart';
import 'package:gymbook/features/on_boarding/Widgets/on_boarding_page.dart';
import 'package:gymbook/features/on_boarding/Widgets/on_boarding_content_panel.dart';
import 'package:gymbook/features/on_boarding/Widgets/on_boarding_skip_button.dart';

class OnBoardingOneViewBody extends StatefulWidget {
  const OnBoardingOneViewBody({super.key});

  @override
  State<OnBoardingOneViewBody> createState() => _OnBoardingOneViewBodyState();
}

class _OnBoardingOneViewBodyState extends State<OnBoardingOneViewBody>
    with SingleTickerProviderStateMixin {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  late AnimationController _animController;
  late Animation<double> _fadeAnim;

  static final List<OnboardingPageData> _pages = [
    const OnboardingPageData(
      image: Assets.onboarding1,
      title: 'Welcome to\nPrime Fit',
      subtitle: 'Your all-in-one fitness platform.',
      accentColor: Color(0xff0EA5E9),
    ),
    const OnboardingPageData(
      image: Assets.onboarding2,
      title: 'Train • Track\n• Manage',
      subtitle: 'Workouts, nutrition, progress tracking, and gym management.',
      accentColor: Color(0xff8B5CF6),
    ),
    const OnboardingPageData(
      image: Assets.onboarding3,
      title: 'Start Your\nJourney',
      subtitle:
          'Join as a Member, Employee, or Partner Admin and achieve more.',
      accentColor: Color(0xff10B981),
    ),
  ];

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _fadeAnim = CurvedAnimation(parent: _animController, curve: Curves.easeIn);
    _animController.forward();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    setState(() => _currentPage = index);
    _animController.reset();
    _animController.forward();
  }

  void _navigate() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOutCubic,
      );
    } else {
      _finishOnboarding();
    }
  }

  void _finishOnboarding() {
    sl<PreferencesStorage>().putBoolean(
      key: PreferencesKeys.hasSeenOnBoarding,
      value: true,
    );
    GoRouter.of(context).pushReplacement(Routes.loginScreen);
  }

  @override
  Widget build(BuildContext context) {
    final currentData = _pages[_currentPage];
    final isLast = _currentPage == _pages.length - 1;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // ─── PageView ─────────────────────────────────────────
          PageView.builder(
            controller: _pageController,
            onPageChanged: _onPageChanged,
            itemCount: _pages.length,
            itemBuilder: (_, i) => OnboardingPage(data: _pages[i]),
          ),

          // ─── Content Panel at bottom ───────────────────────────
          OnBoardingContentPanel(
            currentData: currentData,
            isLast: isLast,
            fadeAnim: _fadeAnim,
            pageController: _pageController,
            pageCount: _pages.length,
            onNavigate: _navigate,
          ),

          // ─── Skip button (top right) ────────────────────────────
          OnBoardingSkipButton(onSkip: _finishOnboarding),
        ],
      ),
    );
  }
}
