import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gymbook/features/on_boarding/Widgets/on_boarding_page.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnBoardingContentPanel extends StatelessWidget {
  final OnboardingPageData currentData;
  final bool isLast;
  final Animation<double> fadeAnim;
  final PageController pageController;
  final int pageCount;
  final VoidCallback onNavigate;

  const OnBoardingContentPanel({
    super.key,
    required this.currentData,
    required this.isLast,
    required this.fadeAnim,
    required this.pageController,
    required this.pageCount,
    required this.onNavigate,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: FadeTransition(
        opacity: fadeAnim,
        child: Padding(
          padding: EdgeInsets.fromLTRB(28.w, 0, 28.w, 52.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Accent tag
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 5.h),
                decoration: BoxDecoration(
                  color: currentData.accentColor.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(
                    color: currentData.accentColor.withValues(alpha: 0.5),
                  ),
                ),
                child: Text(
                  'PRIME FIT',
                  style: TextStyle(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w700,
                    color: currentData.accentColor,
                    letterSpacing: 2.5,
                  ),
                ),
              ),

              SizedBox(height: 16.h),

              // Title
              Text(
                currentData.title,
                style: TextStyle(
                  fontSize: 36.sp,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  height: 1.15,
                  letterSpacing: -0.5,
                ),
              ),

              SizedBox(height: 12.h),

              // Subtitle
              Text(
                currentData.subtitle,
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w400,
                  color: Colors.white.withValues(alpha: 0.7),
                  height: 1.6,
                ),
              ),

              SizedBox(height: 36.h),

              // Indicator + Button row
              Row(
                children: [
                  // Dots indicator
                  SmoothPageIndicator(
                    controller: pageController,
                    count: pageCount,
                    effect: ExpandingDotsEffect(
                      dotHeight: 8,
                      dotWidth: 8,
                      expansionFactor: 3,
                      spacing: 6,
                      activeDotColor: currentData.accentColor,
                      dotColor: Colors.white.withValues(alpha: 0.3),
                    ),
                  ),

                  const Spacer(),

                  // CTA button
                  GestureDetector(
                    onTap: onNavigate,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      height: 54.h,
                      padding: EdgeInsets.symmetric(horizontal: 24.w),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            currentData.accentColor,
                            currentData.accentColor.withValues(alpha: 0.7),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(27.r),
                        boxShadow: [
                          BoxShadow(
                            color: currentData.accentColor.withValues(
                              alpha: 0.45,
                            ),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            isLast ? "Get Started" : "Next",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.3,
                            ),
                          ),
                          SizedBox(width: 8.w),
                          Icon(
                            isLast
                                ? Icons.rocket_launch_rounded
                                : Icons.arrow_forward_rounded,
                            color: Colors.white,
                            size: 18.sp,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
