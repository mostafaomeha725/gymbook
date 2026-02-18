import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gymbook/core/widgets/custom_text.dart';
import 'package:gymbook/core/theme/styles.dart';

class UserTypeCard extends StatelessWidget {
  const UserTypeCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.isActive,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final borderColor = isActive
        ? const Color(0xFF0EA5E9)
        : const Color(0xFFE5E7EB);

    final bgColor = isActive ? const Color(0xFFE0F2FE) : Colors.white;

    final iconColor = isActive
        ? const Color(0xFF0284C7)
        : const Color(0xFF94A3B8);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(18.r),
          border: Border.all(color: borderColor, width: 1.5.w),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(25),
              blurRadius: 10.r,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          children: [
            /// check icon
            if (isActive)
              Positioned(
                top: 0,
                right: 0,
                child: Container(
                  padding: EdgeInsets.all(4.w),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFF0EA5E9),
                  ),
                  child: Icon(Icons.check, color: Colors.white, size: 14.sp),
                ),
              ),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(icon, color: iconColor, size: 28.sp),
                SizedBox(height: 12.h),

                AppText(
                  title,
                  style: font16w600.copyWith(color: const Color(0xff334155)),
                ),

                SizedBox(height: 4.h),

                AppText(
                  subtitle,
                  style: font12w400.copyWith(color: const Color(0xff94A3B8)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
