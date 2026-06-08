import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gymbook/core/theme/styles.dart';
import 'package:gymbook/core/widgets/custom_text.dart';

class ChangePasswordHeader extends StatelessWidget {
  const ChangePasswordHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: Container(
            width: 72.w,
            height: 72.w,
            decoration: const BoxDecoration(
              color: Color(0xFFE0F2FE),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Icon(
                Icons.security,
                color: const Color(0xFF0EA5E9),
                size: 40.w,
              ),
            ),
          ),
        ),
        SizedBox(height: 16.h),
        AppText(
          "For your security, please choose a strong password\nthat you don't use elsewhere.",
          textAlign: TextAlign.center,
          alignment: AlignmentDirectional.center,
          style: font12w400.copyWith(color: const Color(0xFF6B7280)),
        ),
      ],
    );
  }
}
