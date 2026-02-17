import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gymbook/core/widgets/custom_text.dart';
import 'package:gymbook/core/theme/styles.dart';

class CustomerInfoItem extends StatelessWidget {
  const CustomerInfoItem({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
  });

  final IconData icon;
  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 14.h),
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: const Color(0xffF1F5F9),
        borderRadius: BorderRadius.circular(18.r),
      ),
      child: Row(
        children: [
          Container(
            width: 44.w,
            height: 44.w,
            decoration: BoxDecoration(
              color: const Color(0xffE2E8F0),
              borderRadius: BorderRadius.circular(14.r),
            ),
            child: Icon(icon, size: 22.sp, color: const Color(0xff1D9BF0)),
          ),

          SizedBox(width: 14.w),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText(
                title,
                style: font14w500.copyWith(color: const Color(0xff6B7280)),
              ),
              SizedBox(height: 2.h),
              AppText(
                value,
                style: font16w700.copyWith(color: const Color(0xff334155)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
