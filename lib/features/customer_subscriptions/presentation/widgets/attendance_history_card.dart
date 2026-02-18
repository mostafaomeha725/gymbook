import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gymbook/core/theme/styles.dart';
import 'package:gymbook/core/widgets/custom_text.dart';
import 'package:gymbook/features/customer_subscriptions/presentation/widgets/attendance_week_widget.dart';

class AttendanceHistoryCard extends StatelessWidget {
  const AttendanceHistoryCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.w),
      margin: EdgeInsets.symmetric(horizontal: 24.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20.r,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.calendar_month_outlined,
                color: const Color(0xff2196F3),
                size: 22.sp,
              ),
              SizedBox(width: 10.w),
              AppText(
                "Attendance History",
                style: font18w700.copyWith(color: const Color(0xff2E3A46)),
              ),
            ],
          ),

          SizedBox(height: 24.h),
          const AttendanceWeekWidget(
            title: "Week 1",
            days: [false, true, false, true, false, true, false],
          ),
          SizedBox(height: 20.h),

          const AttendanceWeekWidget(
            title: "Week 2",
            days: [false, false, true, false, true, false, true],
          ),
          SizedBox(height: 20.h),

          const AttendanceWeekWidget(
            title: "Week 3",
            days: [false, true, true, false, true, false, true],
          ),
          SizedBox(height: 20.h),

          const AttendanceWeekWidget(
            title: "Week 4",
            days: [false, true, false, true, false, true, false],
          ),
        ],
      ),
    );
  }
}
