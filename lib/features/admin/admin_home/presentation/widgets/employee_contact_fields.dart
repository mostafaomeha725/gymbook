import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gymbook/core/widgets/app_form_field.dart';
import 'package:gymbook/features/admin/admin_home/presentation/widgets/labeled_form_field.dart';

class EmployeeContactFields extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController phoneController;

  const EmployeeContactFields({
    super.key,
    required this.emailController,
    required this.phoneController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LabeledFormField(
          label: 'Email',
          input: AppFormField(
            controller: emailController,
            hintText: 'email@example.com',
            keyboardType: TextInputType.emailAddress,
            prefixIcon: const Icon(Icons.email_outlined, size: 20),
            validator: (val) {
              return null;
            },
          ),
        ),
        SizedBox(height: 16.h),
        LabeledFormField(
          label: 'Phone Number',
          input: AppFormField(
            controller: phoneController,
            hintText: '010-XXXX-XXXX',
            keyboardType: TextInputType.phone,
            prefixIcon: Padding(
              padding: EdgeInsets.only(left: 12.w, right: 8.w),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [Text('🇪🇬', style: TextStyle(fontSize: 16.sp))],
              ),
            ),
            validator: (val) {
              return null;
            },
          ),
        ),
      ],
    );
  }
}
