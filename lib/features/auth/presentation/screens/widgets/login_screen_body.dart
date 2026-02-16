import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:gymbook/core/routes/route_paths.dart';
import 'package:gymbook/core/theme/styles.dart';

import 'package:gymbook/core/widgets/custom_text.dart';

import 'package:gymbook/features/auth/presentation/screens/widgets/gymbook_card.dart';
import 'package:gymbook/features/auth/presentation/screens/widgets/login_widget.dart';

class LoginScreenBody extends StatelessWidget {
  const LoginScreenBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SizedBox(
        height:
            MediaQuery.of(context).size.height -
            MediaQuery.of(context).padding.top -
            MediaQuery.of(context).padding.bottom,
        child: Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  GymbookCard(
                    title: 'GymBook',
                    subtitle: 'Welcome back!',
                    height: 280.h,
                    height1: 80.h,
                  ),

                  Positioned(
                    top: 225.h,
                    left: 56.w,
                    right: 56.w,
                    child: const LoginWidget(),
                  ),
                ],
              ),
            ),

            Padding(
              padding: EdgeInsets.only(bottom: 24.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AppText(
                    "Don't have an account? ",
                    style: font16w400.copyWith(color: const Color(0xff364153)),
                  ),
                  GestureDetector(
                    onTap: () {
                      GoRouter.of(context).push(Routes.joinusScreen);
                    },
                    child: AppText(
                      "Register",
                      style: font16w600.copyWith(
                        color: const Color(0xff0EA5E9),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
