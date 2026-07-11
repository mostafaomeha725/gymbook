import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gymbook/core/theme/styles.dart';
import 'package:gymbook/core/widgets/app_image.dart';
import 'package:gymbook/core/widgets/custom_text.dart';
import 'package:gymbook/features/admin/admin_home/presentation/widgets/get_type_color.dart';
import 'package:gymbook/features/customer/customer_home/presentation/widgets/status_badge.dart';

class MySubscriptionCard extends StatelessWidget {
  final String image;
  final String title;
  final String plan;
  final int sessionsUsed;
  final int sessionsTotal;
  final int? daysLeft;
  final String? expiredDate;
  final bool isExpired;
  final int status;
  final void Function()? onTap;

  const MySubscriptionCard({
    super.key,
    required this.image,
    required this.title,
    required this.plan,
    required this.sessionsUsed,
    required this.sessionsTotal,
    this.daysLeft,
    this.expiredDate,
    this.isExpired = false,
    this.status = 1,
    this.onTap,
  });

  Color _getProgressColor(double progress, bool isExpired) {
    if (isExpired) return Colors.grey;
    if (progress >= 0.70) return const Color(0xFF16A34A); // Green
    if (progress >= 0.40) return const Color(0xFF3B82F6); // Blue
    if (progress >= 0.20) return const Color(0xFFF59E0B); // Orange
    return const Color(0xFFEF4444); // Red
  }

  @override
  Widget build(BuildContext context) {
    final typeColor = GetTypeColor();
    final safeSessionsTotal = sessionsTotal <= 0 ? 1 : sessionsTotal;
    final progress = (sessionsUsed / safeSessionsTotal).clamp(0.0, 1.0);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: [
            BoxShadow(blurRadius: 20.r, color: Colors.black.withOpacity(.05)),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Top Row
            Row(
              children: [
                AppImage(
                  imageUrl: image,
                  width: 60.w,
                  height: 60.w,
                  borderRadius: BorderRadius.circular(15.r),
                  fit: BoxFit.cover,
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText(
                        title,
                        style: font16w700.copyWith(color: Colors.black),
                      ),
                      SizedBox(height: 4.h),
                      AppText(
                        plan,
                        style: font14w400.copyWith(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right, color: Colors.blue),
              ],
            ),

            SizedBox(height: 16.h),

            /// Days Left
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppText("DAYS LEFT", style: font14w500),
                AppText("$sessionsUsed/$sessionsTotal", style: font14w700),
              ],
            ),

            8.verticalSpace,

            /// Progress
            ClipRRect(
              borderRadius: BorderRadius.circular(10.r),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 6.h,
                backgroundColor: Colors.grey.shade300,
                valueColor: AlwaysStoppedAnimation(
                  _getProgressColor(progress, isExpired),
                ),
              ),
            ),

            SizedBox(height: 14.h),

            /// Bottom Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (!isExpired)
                  StatusBadge(
                    text: typeColor.getSubscriptionStatusText(status),
                    color: typeColor.getSubscriptionStatusColor(status),
                    bgColor: typeColor.getSubscriptionStatusBgColor(status),
                  ),
                if (isExpired && expiredDate != null)
                  StatusBadge(
                    text: expiredDate!.trim().isEmpty
                        ? "Expired"
                        : "Expired $expiredDate",
                    color: Colors.grey,
                    bgColor: Colors.grey.withOpacity(.2),
                  ),
                if (isExpired && expiredDate == null)
                  StatusBadge(
                    text: "Expired",
                    color: Colors.grey,
                    bgColor: Colors.grey.withOpacity(.2),
                  ),
                AppText(
                  isExpired ? "Renew" : "View Details",
                  style: font14w700.copyWith(color: Colors.blue),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
