import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gymbook/core/theme/styles.dart';
import 'package:gymbook/core/widgets/custom_text.dart';

class OpeningHoursCard extends StatelessWidget {
  const OpeningHoursCard({super.key});

  @override
  Widget build(BuildContext context) {
    final hours = [
      ('Monday', '6:00 AM - 11:00 PM'),
      ('Tuesday', '6:00 AM - 11:00 PM'),
      ('Wednesday', '6:00 AM - 11:00 PM'),
      ('Thursday', '6:00 AM - 11:00 PM'),
      ('Friday', '6:00 AM - 11:00 PM'),
      ('Saturday', '8:00 AM - 10:00 PM'),
      ('Sunday', '8:00 AM - 10:00 PM'),
    ];

    const activeDay = 'Sunday';

    return Container(
      padding: EdgeInsets.all(16.w),
      margin: EdgeInsets.symmetric(horizontal: 24.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Header
          Row(
            children: [
              Container(
                width: 40.w,
                height: 40.w,
                decoration: const BoxDecoration(
                  color: Color(0xffE6F4FF),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.access_time, color: Color(0xff0EA5E9)),
              ),
              SizedBox(width: 12.w),
              AppText(
                'Opening Hours',
                style: font18w700.copyWith(color: const Color(0xff1E293B)),
              ),
            ],
          ),

          SizedBox(height: 16.h),

          /// Days
          ...hours.map((item) {
            final isActive = item.$1 == activeDay;

            return Container(
              margin: EdgeInsets.only(bottom: 8.h),
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
              decoration: BoxDecoration(
                color: isActive ? const Color(0xffE6F4FF) : Colors.transparent,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  /// Day
                  AppText(
                    item.$1,
                    style: (isActive ? font14w700 : font14w500).copyWith(
                      color: isActive
                          ? const Color(0xff0EA5E9)
                          : const Color(0xff475569),
                    ),
                  ),

                  /// Time
                  AppText(
                    item.$2,
                    style: (isActive ? font14w700 : font14w500).copyWith(
                      color: isActive
                          ? const Color(0xff0EA5E9)
                          : const Color(0xff475569),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
