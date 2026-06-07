import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gymbook/core/theme/styles.dart';
import 'package:gymbook/core/widgets/custom_text.dart';

class EmployeeCardDetails extends StatelessWidget {
  final String name;
  final String role;
  final String phone;

  const EmployeeCardDetails({
    super.key,
    required this.name,
    required this.role,
    required this.phone,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(name, style: font16w600.copyWith(color: Colors.black87)),
        SizedBox(height: 4.h),
        Row(
          children: [
            Icon(Icons.shield_outlined, size: 14.sp, color: Colors.grey),
            SizedBox(width: 4.w),
            AppText(role, style: font12w400.copyWith(color: Colors.grey)),
          ],
        ),
        SizedBox(height: 4.h),
        Row(
          children: [
            Icon(Icons.phone_outlined, size: 14.sp, color: Colors.grey),
            SizedBox(width: 4.w),
            AppText(phone, style: font12w400.copyWith(color: Colors.grey)),
          ],
        ),
      ],
    );
  }
}
