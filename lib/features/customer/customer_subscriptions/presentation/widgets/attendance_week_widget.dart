import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gymbook/core/theme/styles.dart';
import 'package:gymbook/core/widgets/custom_text.dart';

class AttendanceWeekWidget extends StatelessWidget {
  final String title;
  final List<bool> days;

  const AttendanceWeekWidget({
    super.key,
    required this.title,
    required this.days,
  });

  @override
  Widget build(BuildContext context) {
    final labels = ["S", "M", "T", "W", "T", "F", "S"];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(title, style: font16w500.copyWith(color: Colors.grey[700])),

        SizedBox(height: 12.h),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(7, (index) {
            final isActive = days[index];

            return Container(
              width: 38.w,
              height: 38.w,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: isActive
                    ? const Color(0xff2196F3)
                    : Colors.grey.shade200,
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: AppText(
                labels[index],
                style: font14w700.copyWith(
                  color: isActive ? Colors.white : Colors.grey[600],
                ),
                alignment: AlignmentDirectional.center,
              ),
            );
          }),
        ),
      ],
    );
  }
}
