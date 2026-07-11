import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gymbook/core/theme/styles.dart';
import 'package:gymbook/core/widgets/app_form_field.dart';
import 'package:gymbook/core/widgets/custom_text.dart';

class NewUserForm extends StatelessWidget {
  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final TextEditingController phoneController;
  final TextEditingController emailController;

  const NewUserForm({
    super.key,
    required this.firstNameController,
    required this.lastNameController,
    required this.phoneController,
    required this.emailController,
  });

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
              'New Member Details',
              style: font16w700.copyWith(color: const Color(0xff334155)),
            ),
            SizedBox(height: 14.h),
            _fieldLabel('First Name'),
            SizedBox(height: 6.h),
            AppFormField(
              controller: firstNameController,
              hintText: 'Enter first name',
              fillColor: const Color(0xFFF1F5F9),
              borderColor: Colors.transparent,
              radius: 14.r,
              keyboardType: TextInputType.name,
            ),
            SizedBox(height: 12.h),
            _fieldLabel('Last Name'),
            SizedBox(height: 6.h),
            AppFormField(
              controller: lastNameController,
              hintText: 'Enter last name',
              fillColor: const Color(0xFFF1F5F9),
              borderColor: Colors.transparent,
              radius: 14.r,
              keyboardType: TextInputType.name,
            ),
            SizedBox(height: 12.h),
            _fieldLabel('Phone Number'),
            SizedBox(height: 6.h),
            AppFormField(
              controller: phoneController,
              hintText: 'Enter phone number',
              fillColor: const Color(0xFFF1F5F9),
              borderColor: Colors.transparent,
              radius: 14.r,
              keyboardType: TextInputType.phone,
              prefixIcon: Padding(
                padding: EdgeInsets.only(left: 12.w, right: 8.w),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [Text('🇪🇬', style: TextStyle(fontSize: 16.sp))],
                ),
              ),
            ),
            SizedBox(height: 12.h),
            _fieldLabel('Email'),
            SizedBox(height: 6.h),
            AppFormField(
              controller: emailController,
              hintText: 'Enter email address',
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

  Widget _fieldLabel(String text) =>
      AppText(text, style: font14w500.copyWith(color: const Color(0xff364153)));
}
