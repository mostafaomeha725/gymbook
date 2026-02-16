import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gymbook/core/theme/styles.dart';
import 'package:gymbook/core/widgets/bouncing_social_button.dart';
import 'package:gymbook/core/widgets/custom_text.dart';

class SubscriptionsDetailsInfoCard extends StatelessWidget {
  const SubscriptionsDetailsInfoCard({super.key});

  @override
  Widget build(BuildContext context) {
    double progress = 24 / 30;

    return Container(
      padding: EdgeInsets.all(20.w),
      margin: EdgeInsets.symmetric(horizontal: 24.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            // ignore: deprecated_member_use
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20.r,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(
            "Subscription Details",
            style: font18w700.copyWith(color: const Color(0xff2E3A46)),
          ),

          SizedBox(height: 24.h),

          _buildRow("Plan", "Monthly Plan"),

          SizedBox(height: 18.h),

          _buildRow("Price", "500 EGP"),

          SizedBox(height: 18.h),

          _buildRow("Start Date", "February 8, 2026"),

          SizedBox(height: 18.h),

          _buildRow("Expires On", "March 8, 2026"),

          SizedBox(height: 24.h),

          Divider(color: Colors.grey.shade200),

          SizedBox(height: 20.h),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppText(
                "Sessions Used",
                style: font16w500.copyWith(color: Colors.grey[700]),
              ),
              AppText(
                "24/30",
                style: font16w700.copyWith(color: const Color(0xff2E3A46)),
              ),
            ],
          ),

          SizedBox(height: 12.h),

          ClipRRect(
            borderRadius: BorderRadius.circular(8.r),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8.h,
              backgroundColor: Colors.grey.shade300,
              valueColor: const AlwaysStoppedAnimation(Color(0xff0A0A1A)),
            ),
          ),

          SizedBox(height: 28.h),

          BouncingSocialButton(
            text: 'Freeze Subscription',
            borderColor: const Color(0xffF54900),
            icon: Icons.pause,
            onTap: () {},
            textSize: 14.sp,
            textColor: const Color(0xffF54900),
          ),
        ],
      ),
    );
  }

  Widget _buildRow(String title, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        AppText(title, style: font16w400.copyWith(color: Colors.grey[600])),
        AppText(
          value,
          style: font16w700.copyWith(color: const Color(0xff2E3A46)),
        ),
      ],
    );
  }
}
