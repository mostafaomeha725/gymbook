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
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 56.w,
          height: 56.w,
          decoration: const BoxDecoration(
            color: Color(0xffF0F9FF),
            shape: BoxShape.circle,
          ),
          child: Icon(item.icon, color: const Color(0xff0EA5E9), size: 23.sp),
        ),
        SizedBox(height: 9.h),
        AppText(
          item.label,
          alignment: AlignmentDirectional.center,
          style: font12w400.copyWith(color: const Color(0xff64748B)),
        ),
      ],
    );
  }
}
