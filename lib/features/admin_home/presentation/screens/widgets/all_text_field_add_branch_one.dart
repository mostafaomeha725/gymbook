import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:gymbook/core/routes/route_paths.dart';
import 'package:gymbook/core/theme/styles.dart';
import 'package:gymbook/core/widgets/app_form_field.dart';
import 'package:gymbook/core/widgets/custom_button.dart';
import 'package:gymbook/core/widgets/custom_text.dart';
import 'package:gymbook/features/auth/presentation/screens/otp_screen.dart';
import 'package:gymbook/features/auth/presentation/screens/widgets/gym_type_selector.dart';

class AllTextFieldAddBranchOne extends StatefulWidget {
  const AllTextFieldAddBranchOne({super.key});

  @override
  State<AllTextFieldAddBranchOne> createState() =>
      _AllTextFieldAddBranchOneState();
}

class _AllTextFieldAddBranchOneState extends State<AllTextFieldAddBranchOne> {
  final TextEditingController phoneNumbercontroller = TextEditingController();
  final TextEditingController ownerNamecontroller = TextEditingController();
  final TextEditingController emailcontroller = TextEditingController();

  @override
  void dispose() {
    phoneNumbercontroller.dispose();
    emailcontroller.dispose();
    ownerNamecontroller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 24.h),

          AppText(
            'Owner Name',
            style: font14w500.copyWith(color: const Color(0xff364153)),
          ),
          SizedBox(height: 8.h),
          AppFormField(
            controller: ownerNamecontroller,
            hintText: 'Enter your full name',
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
            'Email Address',
            style: font14w500.copyWith(color: const Color(0xff364153)),
          ),
          SizedBox(height: 8.h),
          AppFormField(
            controller: ownerNamecontroller,
            hintText: 'your.email@example.com',
            maxLines: 1,
            prefixIcon: Padding(
              padding: EdgeInsets.only(left: 8.w),
              child: Icon(Icons.email_outlined, size: 22.sp),
            ),
            radius: 22.r,
          ),
          SizedBox(height: 24.h),

          GymTypeSelector(onChanged: (value) {}),

          SizedBox(height: 24.h),

          AppButton(
            text: 'Continue',
            onPressed: () {
              GoRouter.of(
                context,
              ).push(Routes.otpScreen, extra: OtpSource.business);
            },
            textSize: 16.sp,
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF0EA5E9), Color(0xFF0284C7)],
            ),
          ),
          SizedBox(height: 48.h),
        ],
      ),
    );
  }
}
