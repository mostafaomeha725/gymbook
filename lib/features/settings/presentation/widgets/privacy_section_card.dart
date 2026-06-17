import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gymbook/core/theme/styles.dart';
import 'package:gymbook/core/widgets/custom_text.dart';

class PrivacySectionCard extends StatelessWidget {
  final String title;
  final IconData? icon;
  final Color? iconColor;
  final Color? iconBgColor;
  final String description;
  final List<String> bulletPoints;
  final Widget? extraContent;

  const PrivacySectionCard({
    super.key,
    required this.title,
    this.icon,
    this.iconColor,
    this.iconBgColor,
    required this.description,
    this.bulletPoints = const [],
    this.extraContent,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.grey.shade200, width: 1.w),
        boxShadow: [
          BoxShadow(
            // ignore: deprecated_member_use
            color: Colors.black.withOpacity(0.09),
            blurRadius: 20.r,
            offset: Offset(0, 10.h),
            spreadRadius: -5.r,
          ),
          BoxShadow(
            // ignore: deprecated_member_use
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8.r,
            offset: Offset(0, 4.h),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (icon != null)
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                    color: iconBgColor,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Icon(icon, color: iconColor, size: 20.sp),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: AppText(
                    title,
                    overflow: TextOverflow.visible,
                    style: font16w600.copyWith(color: Colors.black87),
                  ),
                ),
              ],
            )
          else
            AppText(
              title,
              overflow: TextOverflow.visible,
              style: font16w600.copyWith(color: Colors.black87),
            ),

          SizedBox(height: 16.h),

          AppText(
            description,
            overflow: TextOverflow.visible,
            style: font14w500.copyWith(color: Colors.grey[700], height: 1.5),
          ),

          if (bulletPoints.isNotEmpty) ...[
            SizedBox(height: 16.h),
            ...bulletPoints.map(
              (point) => Padding(
                padding: EdgeInsets.only(bottom: 12.h),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 6.h, right: 10.w),
                      child: CircleAvatar(
                        radius: 3.r,
                        backgroundColor: Colors.grey[600],
                      ),
                    ),
                    Expanded(
                      child: AppText(
                        point,
                        overflow: TextOverflow.visible,
                        style: font12w500.copyWith(
                          color: Colors.grey[700],
                          height: 1.4.h,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],

          if (extraContent != null) ...[SizedBox(height: 16.h), extraContent!],
        ],
      ),
    );
  }
}
