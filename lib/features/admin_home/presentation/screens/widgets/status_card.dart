import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gymbook/core/widgets/custom_text.dart';
import 'package:gymbook/core/theme/styles.dart';

class StatusCard extends StatelessWidget {
  const StatusCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.gradient,
    this.iconColor,
    this.isCenter = false,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Gradient? gradient;
  final Color? iconColor;
  final bool isCenter;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        gradient: gradient,
        color: gradient == null ? Colors.white : null,
        borderRadius: BorderRadius.circular(22.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 16.r,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: isCenter
            ? MainAxisAlignment.center
            : MainAxisAlignment.start,
        crossAxisAlignment: isCenter
            ? CrossAxisAlignment.center
            : CrossAxisAlignment.start,
        children: [
          Icon(icon, color: iconColor ?? Colors.white, size: 28.sp),

          SizedBox(height: 12.h),

          FittedBox(
            fit: BoxFit.scaleDown,
            child: AppText(
              title,
              style: font18w700.copyWith(
                color: gradient != null
                    ? Colors.white
                    : const Color(0xff2C3E50),
              ),
            ),
          ),

          SizedBox(height: 4.h),

          FittedBox(
            fit: BoxFit.scaleDown,
            child: AppText(
              subtitle,
              style: font14w500.copyWith(
                color: gradient != null
                    ? Colors.white.withValues(alpha: 0.9)
                    : Colors.grey,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
