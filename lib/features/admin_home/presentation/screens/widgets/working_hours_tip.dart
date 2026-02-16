import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gymbook/core/theme/styles.dart';
import 'package:gymbook/core/widgets/custom_text.dart';

class WorkingHoursTip extends StatelessWidget {
  final String? tip;

  const WorkingHoursTip({super.key, this.tip});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8.w),
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        color: const Color(0xffEFF6FF),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color(0xffBFDBFE)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline, color: const Color(0xFF0EA5E9), size: 20.sp),
          SizedBox(width: 12.w),
          Expanded(
            child: AppText(
              tip ??
                  'Tip: Toggle off any day to mark the branch as completely closed. This is useful for holidays or special occasions.',
              maxLines: 6,
              style: font14w700.copyWith(color: const Color(0xff364153)),
            ),
          ),
        ],
      ),
    );
  }
}
