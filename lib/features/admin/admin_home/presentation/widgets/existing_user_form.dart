import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gymbook/core/theme/styles.dart';
import 'package:gymbook/core/widgets/app_form_field.dart';
import 'package:gymbook/core/widgets/custom_text.dart';

class ExistingUserForm extends StatelessWidget {
  final TextEditingController emailController;

  const ExistingUserForm({super.key, required this.emailController});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 22.w),
      child: Container(
        padding: EdgeInsets.all(18.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(5),
              blurRadius: 14.r,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppText(
              'User Email',
              style: font16w700.copyWith(color: const Color(0xff334155)),
            ),
            SizedBox(height: 14.h),
            AppText(
              'Email',
              style: font14w500.copyWith(color: const Color(0xff364153)),
            ),
            SizedBox(height: 6.h),
            AppFormField(
              controller: emailController,
              hintText: 'Enter user email',
              fillColor: const Color(0xFFF1F5F9),
              borderColor: Colors.transparent,
              radius: 14.r,
              keyboardType: TextInputType.emailAddress,
            ),
          ],
        ),
      ),
    );
  }
}
