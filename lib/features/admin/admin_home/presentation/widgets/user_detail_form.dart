import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gymbook/core/widgets/app_form_field.dart';
import 'package:gymbook/core/widgets/custom_text.dart';
import 'package:gymbook/core/theme/styles.dart';

class UserDetailsForm extends StatelessWidget {
  const UserDetailsForm({
    super.key,
    required this.nameController,
    required this.phoneController,
    required this.emailController,
    required this.isExistingUser,
  });

  final TextEditingController nameController;
  final TextEditingController phoneController;
  final TextEditingController emailController;

  final bool isExistingUser;

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
              "User Details",
              style: font16w700.copyWith(color: const Color(0xff334155)),
            ),

            SizedBox(height: 18.h),

            if (!isExistingUser) ...[
              _label("Full Name"),
              SizedBox(height: 6.h),
              AppFormField(
                controller: nameController,
                hintText: "Enter full name",
                fillColor: const Color(0xFFF1F5F9),
                borderColor: Colors.transparent,
                radius: 14.r,
              ),

              SizedBox(height: 16.h),

              _label("Contact Number"),
              SizedBox(height: 6.h),
              AppFormField(
                controller: phoneController,
                hintText: "+20 100 123 4567",
                keyboardType: TextInputType.phone,
                fillColor: const Color(0xFFF1F5F9),
                borderColor: Colors.transparent,
                radius: 14.r,
              ),

              SizedBox(height: 16.h),
            ],

            _label("Email"),
            SizedBox(height: 6.h),
            AppFormField(
              controller: emailController,
              hintText: "user@email.com",
              keyboardType: TextInputType.emailAddress,
              fillColor: const Color(0xFFF1F5F9),
              borderColor: Colors.transparent,
              radius: 14.r,
            ),
          ],
        ),
      ),
    );
  }

  Widget _label(String text) {
    return AppText(
      text,
      style: font14w700.copyWith(color: const Color(0xff475569)),
    );
  }
}
