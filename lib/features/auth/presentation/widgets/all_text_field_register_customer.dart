import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:gymbook/core/routes/route_paths.dart';
import 'package:gymbook/core/theme/styles.dart';
import 'package:gymbook/core/widgets/app_form_field.dart';
import 'package:gymbook/core/widgets/custom_button.dart';
import 'package:gymbook/core/widgets/custom_text.dart';
import 'package:gymbook/features/auth/presentation/screens/otp_screen.dart';
import 'package:gymbook/features/auth/presentation/widgets/password_condition_widget.dart';

class AllTextFieldRegisterCustomer extends StatefulWidget {
  const AllTextFieldRegisterCustomer({super.key});

  @override
  State<AllTextFieldRegisterCustomer> createState() =>
      _AllTextFieldRegisterCustomerState();
}

class _AllTextFieldRegisterCustomerState
    extends State<AllTextFieldRegisterCustomer> {
  final TextEditingController phoneNumbercontroller = TextEditingController();
  final TextEditingController firstNamecontroller = TextEditingController();
  final TextEditingController lastNamecontroller = TextEditingController();
  final TextEditingController passwordcontroller = TextEditingController();
  final TextEditingController confirmpasswordcontroller =
      TextEditingController();

  bool obscurePassword = true;

  @override
  void initState() {
    super.initState();
    passwordcontroller.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    phoneNumbercontroller.dispose();
    firstNamecontroller.dispose();
    lastNamecontroller.dispose();
    passwordcontroller.dispose();
    confirmpasswordcontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final password = passwordcontroller.text;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 52.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(
            'First Name',
            style: font14w500.copyWith(color: const Color(0xff364153)),
          ),
          SizedBox(height: 8.h),
          AppFormField(
            controller: firstNamecontroller,
            hintText: 'Enter your first name',
            maxLines: 1,
            prefixIcon: Padding(
              padding: EdgeInsets.only(left: 8.w),
              child: Icon(Icons.person_outline, size: 22.sp),
            ),
            radius: 22.r,
          ),

          SizedBox(height: 16.h),

          AppText(
            'Last Name',
            style: font14w500.copyWith(color: const Color(0xff364153)),
          ),
          SizedBox(height: 8.h),
          AppFormField(
            controller: lastNamecontroller,
            hintText: 'Enter your last name',
            maxLines: 1,
            prefixIcon: Padding(
              padding: EdgeInsets.only(left: 8.w),
              child: Icon(Icons.person_outline, size: 22.sp),
            ),
            radius: 22.r,
          ),

          SizedBox(height: 16.h),

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
            hintText: 'Create a password',
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

          SizedBox(height: 8.h),

          PasswordConditionsWidget(password: password),

          SizedBox(height: 16.h),

          AppText(
            'Confirm Password',
            style: font14w500.copyWith(color: const Color(0xff364153)),
          ),
          SizedBox(height: 8.h),
          AppFormField(
            controller: confirmpasswordcontroller,
            hintText: 'Confirm your password',
            maxLines: 1,
            obsecureText: obscurePassword,
            prefixIcon: Padding(
              padding: EdgeInsets.only(left: 8.w),
              child: Icon(Icons.lock_outline, size: 22.sp),
            ),
            radius: 22.r,
          ),

          SizedBox(height: 24.h),

          AppButton(
            text: 'Continue',
            onPressed: () {
              GoRouter.of(
                context,
              ).push(Routes.otpScreen, extra: OtpSource.customer);
            },
            textSize: 16.sp,
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF0EA5E9), Color(0xFF0284C7)],
            ),
          ),
        ],
      ),
    );
  }
}
