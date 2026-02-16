import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:gymbook/core/routes/route_paths.dart';
import 'package:gymbook/core/theme/styles.dart';
import 'package:gymbook/core/widgets/bouncing_social_button.dart';
import 'package:gymbook/core/widgets/custom_text.dart';

class ProfileCard extends StatelessWidget {
  const ProfileCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 12.w),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15.r,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              /// Avatar
              Container(
                width: 78.w,
                height: 78.h,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [Color(0xFF0EA5E9), Color(0xFF0284C7)],
                  ),
                ),
                alignment: Alignment.center,
                child: AppText(
                  "AH",
                  style: font20w500.copyWith(color: Colors.white),
                  alignment: AlignmentDirectional.center,
                ),
              ),

              SizedBox(width: 16.w),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText("Ahmed Hassan", style: font16w700),
                  SizedBox(height: 4.h),
                  AppText(
                    "+20 123 456 7890",
                    style: font14w400.copyWith(color: Colors.grey),
                  ),
                ],
              ),
            ],
          ),

          SizedBox(height: 16.h),

          BouncingSocialButton(
            text: 'Edit Profile',

            borderColor: Colors.grey,

            icon: Icons.person_outline,
            onTap: () {
              GoRouter.of(context).push(Routes.editProfileScreen);
            },
            textSize: 14.sp,
            textColor: const Color(0XFF2C3E50),
          ),
        ],
      ),
    );
  }
}
