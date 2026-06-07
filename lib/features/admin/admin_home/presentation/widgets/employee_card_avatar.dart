import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gymbook/core/theme/styles.dart';
import 'package:gymbook/core/widgets/custom_text.dart';

class EmployeeCardAvatar extends StatelessWidget {
  final String initials;

  const EmployeeCardAvatar({super.key, required this.initials});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48.w,
      height: 48.w,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: const Color(0xFFD0E8F2),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: AppText(
        initials,
        style: font16w600.copyWith(color: const Color(0xFF0EA5E9)),
        alignment: AlignmentDirectional.center,
      ),
    );
  }
}
