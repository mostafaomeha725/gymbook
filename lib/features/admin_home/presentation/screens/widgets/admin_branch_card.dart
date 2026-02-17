import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gymbook/core/widgets/custom_text.dart';
import 'package:gymbook/core/theme/styles.dart';

class AdminBranchCard extends StatelessWidget {
  const AdminBranchCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.gradient,
    this.hasStatus = false,
    this.statusText = 'true',
    this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Gradient gradient;
  final bool hasStatus;
  final String statusText;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 105.h,
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(24.r),
          boxShadow: [
            BoxShadow(
              // ignore: deprecated_member_use
              color: Colors.black.withOpacity(0.15),
              blurRadius: 12.r,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                hasStatus
                    ? Container(
                        height: 48.h,
                        width: 48.w,
                        decoration: BoxDecoration(
                          // ignore: deprecated_member_use
                          color: Colors.white.withOpacity(0.25),
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                        child: Icon(icon, color: Colors.white, size: 26.sp),
                      )
                    : Icon(icon, color: Colors.white, size: 26.sp),

                if (!hasStatus)
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 6.h,
                    ),
                    decoration: BoxDecoration(
                      // ignore: deprecated_member_use
                      color: Colors.white.withOpacity(0.25),
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: AppText(
                      statusText,
                      style: font14w500.copyWith(color: Colors.white),
                    ),
                  ),
              ],
            ),

            AppText(title, style: font18w700.copyWith(color: Colors.white)),
            AppText(
              subtitle,
              style: font14w500.copyWith(color: Colors.white70),
            ),
          ],
        ),
      ),
    );
  }
}
