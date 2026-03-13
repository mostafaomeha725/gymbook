import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gymbook/core/theme/styles.dart';
import 'package:gymbook/core/widgets/custom_text.dart';

class AmenityItem {
  final IconData icon;
  final String label;

  const AmenityItem({required this.icon, required this.label});
}

class AmenityWidget extends StatelessWidget {
  final AmenityItem item;

  const AmenityWidget({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 72.w,
      child: Column(
        children: [
          Container(
            width: 52.w,
            height: 52.w,
            decoration: const BoxDecoration(
              color: Color(0xffE6F4FF),
              shape: BoxShape.circle,
            ),
            child: Icon(item.icon, color: const Color(0xff0EA5E9), size: 26.sp),
          ),
          SizedBox(height: 8.h),
          AppText(
            item.label,
            alignment: AlignmentDirectional.center,
            style: font14w500.copyWith(color: const Color(0xff334155)),
          ),
        ],
      ),
    );
  }
}
