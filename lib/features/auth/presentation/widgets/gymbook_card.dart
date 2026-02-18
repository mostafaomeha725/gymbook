import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gymbook/core/theme/styles.dart';
import 'package:gymbook/core/widgets/custom_text.dart';
import 'package:gymbook/core/widgets/custom_nav_bar.dart';

class GymbookCard extends StatelessWidget {
  const GymbookCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.height,
    required this.height1,
    this.appbarText,
    this.showAppBar = false,
  });
  final String title;
  final String subtitle;
  final double height;
  final double height1;
  final String? appbarText;
  final bool showAppBar;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 32.w),
      child: Container(
        width: double.infinity,
        height: height,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF0EA5E9), Color(0xFF0284C7)],
          ),
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
        ),
        child: Column(
          children: [
            SizedBox(height: height1),
            if (showAppBar)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => CustomNavBar.of(context)?.goBack(),

                      child: Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                        size: 24.sp,
                      ),
                    ),
                    SizedBox(width: 16.w),
                    if (appbarText != null)
                      AppText(
                        appbarText!,
                        style: font20w700.copyWith(color: Colors.white),
                      ),
                  ],
                ),
              ),

            AppText(
              title,
              style: showAppBar
                  ? font24w700.copyWith(color: Colors.white)
                  : font36w800.copyWith(color: Colors.white),
              alignment: AlignmentDirectional.center,
            ),
            SizedBox(height: showAppBar ? 12.h : 22.h),

            AppText(
              subtitle,
              style: showAppBar
                  ? font16w400.copyWith(color: const Color(0xffFFFFE5))
                  : font18w400.copyWith(color: const Color(0xffFFFFE5)),
              alignment: AlignmentDirectional.center,
            ),
          ],
        ),
      ),
    );
  }
}
