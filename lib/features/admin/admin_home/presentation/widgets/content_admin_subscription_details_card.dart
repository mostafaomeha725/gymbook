import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gymbook/core/theme/styles.dart';
import 'package:gymbook/core/widgets/custom_text.dart';

class ContentAdminSubscriptionDetailsCard extends StatelessWidget {
  const ContentAdminSubscriptionDetailsCard({
    super.key,
    required this.name,
    required this.plan,
    required this.price,
    required this.status,
    required this.remaining,
    required this.total,
    required this.progress,
  });

  final String name;
  final String plan;
  final String price;
  final String status;
  final int remaining;
  final int total;
  final double progress;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: 22.w, left: 22.w, bottom: 26.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.25),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: AppText(
                  status,
                  style: font14w700.copyWith(color: Colors.white),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 12.h, right: 8.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    AppText(
                      price,
                      style: font26w700.copyWith(color: Colors.white),
                    ),
                    AppText(
                      "EGP",
                      style: font14w400.copyWith(
                        color: Colors.white.withValues(alpha: 0.85),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(
                      name,
                      style: font24w700.copyWith(color: Colors.white),
                    ),
                    SizedBox(height: 4.h),
                    AppText(
                      plan,
                      style: font16w500.copyWith(
                        color: Colors.white.withValues(alpha: 0.85),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: 16.h),

          Row(
            children: [
              AppText(
                "Time Remaining",
                style: font14w500.copyWith(
                  color: Colors.white.withValues(alpha: 0.85),
                ),
              ),
              const Spacer(),
              AppText(
                "$remaining / $total days",
                style: font14w700.copyWith(color: Colors.white),
              ),
            ],
          ),

          SizedBox(height: 8.h),

          ClipRRect(
            borderRadius: BorderRadius.circular(20.r),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 10.h,
              backgroundColor: Colors.white.withValues(alpha: 0.3),
              valueColor: const AlwaysStoppedAnimation(Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
