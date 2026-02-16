import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:gymbook/core/constants/app_assets.dart';
import 'package:gymbook/core/routes/route_paths.dart';
import 'package:gymbook/core/theme/styles.dart';
import 'package:gymbook/core/widgets/app_form_field.dart';
import 'package:gymbook/core/widgets/bouncing_social_button.dart';
import 'package:gymbook/core/widgets/custom_button.dart';
import 'package:gymbook/core/widgets/custom_text.dart';
import 'package:gymbook/features/auth/presentation/screens/widgets/divider_widget.dart';

class LoginWidget extends StatefulWidget {
  const LoginWidget({super.key});

  @override
  State<LoginWidget> createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  final TextEditingController phoneNumbercontroller = TextEditingController();

  final TextEditingController passwordcontroller = TextEditingController();

  bool obscurePassword = true;

  @override
  void dispose() {
    phoneNumbercontroller.dispose();
    passwordcontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            blurRadius: 35,
            spreadRadius: 5,
            offset: const Offset(0, 15),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 12.h),
          AppText(
            'Sign In',
            style: font24w700.copyWith(color: Colors.black),
            alignment: AlignmentDirectional.center,
          ),
          SizedBox(height: 24.h),
          AppText(
            'Phone Number',
            style: font14w500.copyWith(color: const Color(0xff364153)),
          ),
          SizedBox(height: 8.h),
          AppFormField(
            controller: phoneNumbercontroller,
            hintText: '+20 XXX XXX XXX',
            maxLines: 1,
            prefixIcon: Padding(
              padding: EdgeInsets.only(left: 8.w),
              child: Icon(Icons.phone_outlined, size: 22.sp),
            ),
            radius: 22.r,
          ),
          SizedBox(height: 16.h),
          AppText(
            'Password',
            style: font14w500.copyWith(color: const Color(0xff364153)),
          ),
          SizedBox(height: 8.h),
          AppFormField(
            controller: passwordcontroller,
            hintText: 'Enter your password',
            maxLines: 1,
            obsecureText: obscurePassword,
            prefixIcon: Padding(
              padding: EdgeInsets.only(left: 8.w),
              child: Icon(Icons.lock_outline, size: 22.sp),
            ),
            radius: 22.r,
            suffixIcon: IconButton(
              icon: Icon(
                obscurePassword
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
              ),
              onPressed: () =>
                  setState(() => obscurePassword = !obscurePassword),
            ),
          ),
          SizedBox(height: 24.h),
          AppButton(
            text: 'Login',
            onPressed: () {
              GoRouter.of(context).pushReplacement(Routes.mainNavigationScreen);
            },
            textSize: 16.sp,
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF0EA5E9), Color(0xFF0284C7)],
            ),
          ),
          SizedBox(height: 18.h),
          AppText(
            'Forgot Password?',
            alignment: AlignmentDirectional.center,
            style: font14w500.copyWith(color: const Color(0xff0EA5E9)),
          ),
          SizedBox(height: 24.h),
          const DividerWidget(),
          SizedBox(height: 24.h),
          BouncingSocialButton(
            text: "Continue with Google",
            assetName: Assets.google,
            onTap: () {},
            textColor: Colors.black,
          ),
        ],
      ),
    );
  }
}
