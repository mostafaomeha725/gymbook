import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gymbook/core/widgets/custom_text.dart';
import 'package:gymbook/core/theme/styles.dart';

class FreezeAvailableBox extends StatelessWidget {
  const FreezeAvailableBox({super.key, required this.freezes});

  final int freezes;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 22.h),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(204),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Column(
        children: [
          Row(
            children: [
              AppText(
                "Freezes Available",
                style: font16w600.copyWith(color: const Color(0xff334155)),
              ),
              const Spacer(),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: const Color(0xFF2563EB),
                  borderRadius: BorderRadius.circular(14.r),
                ),
                child: Icon(Icons.ac_unit, color: Colors.white, size: 18.sp),
              ),
              SizedBox(width: 10.w),
              AppText(
                "$freezes",
                style: font18w700.copyWith(color: const Color(0xFF2563EB)),
              ),
            ],
          ),

          SizedBox(height: 16.h),

          AppText(
            "No freeze history yet",
            style: font14w500.copyWith(color: const Color(0xff6B7280)),
            alignment: AlignmentDirectional.center,
          ),
        ],
      ),
    );
  }
}
