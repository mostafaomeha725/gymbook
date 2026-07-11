import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gymbook/core/theme/styles.dart';
import 'package:gymbook/core/widgets/app_form_field.dart';
import 'package:gymbook/core/widgets/custom_button.dart';
import 'package:gymbook/core/widgets/custom_text.dart';
import 'package:gymbook/features/auth/presentation/widgets/gym_type_selector.dart';

class AllTextFieldAddBranchOneContent extends StatelessWidget {
  final TextEditingController branchNameController;
  final TextEditingController phoneNumberController;
  final TextEditingController emailController;
  final bool isEditMode;
  final String branchNameHint;
  final String phoneNumberHint;
  final String emailHint;
  final GymType? initialGymType;
  final String submitText;
  final ValueChanged<GymType> onGymTypeChanged;
  final VoidCallback onSubmit;

  const AllTextFieldAddBranchOneContent({
    super.key,
    required this.branchNameController,
    required this.phoneNumberController,
    required this.emailController,
    required this.isEditMode,
    required this.branchNameHint,
    required this.phoneNumberHint,
    required this.emailHint,
    required this.initialGymType,
    required this.submitText,
    required this.onGymTypeChanged,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 24.h),
          AppText(
            'Branch Name',
            style: font14w500.copyWith(color: const Color(0xff364153)),
          ),
          SizedBox(height: 8.h),
          AppFormField(
            controller: branchNameController,
            hintText: branchNameHint,
            maxLines: 1,
            prefixIcon: Padding(
              padding: EdgeInsets.only(left: 8.w),
              child: Icon(Icons.store_outlined, size: 22.sp),
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
            controller: phoneNumberController,
            hintText: phoneNumberHint,
            maxLines: 1,
            keyboardType: TextInputType.phone,
            prefixIcon: Padding(
              padding: EdgeInsets.only(left: 12.w, right: 8.w),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [Text('🇪🇬', style: TextStyle(fontSize: 16.sp))],
              ),
            ),
            radius: 22.r,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return null; // Don't show error until user tries to submit
              }

              return null;
            },
          ),
          SizedBox(height: 16.h),
          AppText(
            'Email Address',
            style: font14w500.copyWith(color: const Color(0xff364153)),
          ),
          SizedBox(height: 8.h),
          AppFormField(
            controller: emailController,
            hintText: emailHint,
            maxLines: 1,
            keyboardType: TextInputType.emailAddress,
            prefixIcon: Padding(
              padding: EdgeInsets.only(left: 8.w),
              child: Icon(Icons.email_outlined, size: 22.sp),
            ),
            radius: 22.r,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return null; // Don't show error until user tries to submit
              }

              return null;
            },
          ),
          SizedBox(height: 24.h),
          GymTypeSelector(
            initialValue: initialGymType,
            onChanged: onGymTypeChanged,
          ),
          SizedBox(height: 24.h),
          AppButton(
            text: submitText,
            onPressed: onSubmit,
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
