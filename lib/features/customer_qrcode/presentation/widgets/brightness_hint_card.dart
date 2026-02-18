import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gymbook/core/theme/styles.dart';
import 'package:gymbook/core/widgets/custom_text.dart';

class BrightnessHintCard extends StatelessWidget {
  const BrightnessHintCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 22.h),
      decoration: BoxDecoration(
        color: const Color(0xFFE0F2FE),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 4.h),
            child: Icon(Icons.light_mode, color: Colors.amber, size: 26.sp),
          ),

          SizedBox(width: 14.w),
          Expanded(
            child: AppText(
              "Keep your screen brightness high for better scanning",
              style: font14w500.copyWith(color: const Color(0xFF0284C7)),
              maxLines: 2,
            ),
          ),
        ],
      ),
    );
  }
}
