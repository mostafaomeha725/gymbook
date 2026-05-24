import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gymbook/core/theme/styles.dart';
import 'package:gymbook/core/widgets/custom_text.dart';

class ContentPackageSelectCard extends StatelessWidget {
  const ContentPackageSelectCard({
    super.key,
    required this.title,
    required this.duration,
    required this.price,
    required this.freezes,
    required this.icon,
    required this.isActive,
  });

  final String title;
  final String duration;
  final String price;
  final String freezes;
  final IconData icon;
  final bool isActive;

  static const mainColor = Color(0xFF0EA5E9);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 56.h,
              width: 56.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.r),
                gradient: isActive
                    ? const LinearGradient(
                        colors: [Color(0xFF38BDF8), Color(0xFF0EA5E9)],
                      )
                    : null,
                color: isActive ? null : Colors.grey.shade200,
              ),
              child: Icon(
                icon,
                color: isActive ? Colors.white : Colors.grey,
                size: 26.sp,
              ),
            ),

            SizedBox(width: 14.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(
                    title,
                    style: font18w700.copyWith(color: const Color(0xff334155)),
                  ),
                  SizedBox(height: 8.h),
                  Row(
                    children: [
                      _info(Icons.calendar_month_outlined, duration),
                      SizedBox(width: 20.w),
                      _info(Icons.attach_money, "$price EGP"),
                    ],
                  ),

                  SizedBox(height: 6.h),
                  _info(Icons.ac_unit, "$freezes Freeze"),
                ],
              ),
            ),
          ],
        ),
        if (isActive)
          Positioned(
            top: 0,
            right: 0,
            child: Container(
              height: 32.h,
              width: 32.w,
              decoration: const BoxDecoration(
                color: mainColor,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.check, color: Colors.white, size: 18.sp),
            ),
          ),
      ],
    );
  }

  Widget _info(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16.sp, color: Colors.grey),
        SizedBox(width: 4.w),
        AppText(text, style: font14w500.copyWith(color: Colors.grey)),
      ],
    );
  }
}
