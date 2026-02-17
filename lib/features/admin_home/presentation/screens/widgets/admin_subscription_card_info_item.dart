import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gymbook/core/widgets/custom_text.dart';
import 'package:gymbook/core/theme/styles.dart';

class AdminSubscriptionCardInfoItem extends StatelessWidget {
  const AdminSubscriptionCardInfoItem({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
    this.valueColor,
  });

  final IconData icon;
  final String title;
  final String value;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18.sp, color: const Color(0xff9CA3AF)),

        SizedBox(width: 8.w),

        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppText(
              title,
              style: font12w500.copyWith(color: const Color(0xff6A7282)),
            ),

            SizedBox(height: 2.h),

            AppText(
              value,
              style: font14w700.copyWith(
                color: valueColor ?? const Color(0xff334155),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
