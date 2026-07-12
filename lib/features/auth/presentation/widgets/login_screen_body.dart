import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:gymbook/core/routes/route_paths.dart';
import 'package:gymbook/core/theme/styles.dart';

import 'package:gymbook/core/widgets/custom_text.dart';
import 'package:gymbook/features/auth/presentation/widgets/gymbook_card.dart';
import 'package:gymbook/features/auth/presentation/widgets/login_widget.dart';

class LoginScreenBody extends StatelessWidget {
  const LoginScreenBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              GymbookCard(
                title: 'Prime Fit',
                subtitle: 'Welcome back!',
                height: 220.h,
                height1: 40.h,
              ),
              Padding(
                padding: EdgeInsets.only(top: 160.h, left: 48.w, right: 48.w),
                child: const LoginWidget(),
              ),
            ],
          ),
          SizedBox(height: 24.h),
          Row(
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
                  style: font16w600.copyWith(color: const Color(0xff0EA5E9)),
                ),
              ),
            ],
          ),
          SizedBox(height: 24.h),
        ],
      ),
    );
  }
}
