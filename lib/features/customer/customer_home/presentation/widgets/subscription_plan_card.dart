import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gymbook/core/theme/styles.dart';
import 'package:gymbook/core/widgets/custom_button.dart';
import 'package:gymbook/core/widgets/custom_text.dart';

class SubscriptionPlanCard extends StatelessWidget {
  final PlanModel plan;
  final VoidCallback? onSubscribe;

  const SubscriptionPlanCard({super.key, required this.plan, this.onSubscribe});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 240.w,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24.r),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xff0EA5E9), Color(0xff0284C7)],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Title
          AppText(
            plan.title,
            style: font18w700.copyWith(color: Colors.white, height: 1.2),
            maxLines: 2,
          ),

          SizedBox(height: 16.h),

          /// Price
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              AppText(
                '${plan.price.toStringAsFixed(plan.price % 1 == 0 ? 0 : 2)} EGP',
                style: font32w700.copyWith(color: Colors.white),
              ),
            ],
          ),
          SizedBox(height: 4.h),
          AppText(
            plan.duration,
            style: font14w400.copyWith(
              color: Colors.white.withValues(alpha: 0.9),
            ),
          ),

          SizedBox(height: 16.h),

          /// Freeze Info
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Row(
              children: [
                Icon(Icons.ac_unit_rounded, color: Colors.white, size: 18.sp),
                SizedBox(width: 8.w),
                Expanded(
                  child: AppText(
                    '${plan.numberOfFreezes} Freezes (${plan.freezeDurationInDays} Days)',
                    style: font12w500.copyWith(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),

          const Spacer(),

          AppButton(
            text: 'Subscribe',
            onPressed: () {
              if (onSubscribe != null) onSubscribe!();
            },
            color: Colors.white,
            textColor: const Color(0xff0EA5E9),
          ),
        ],
      ),
    );
  }
}

class PlanModel {
  final int id;
  final String title;
  final double price;
  final String duration;
  final int numberOfFreezes;
  final int freezeDurationInDays;

  const PlanModel({
    required this.id,
    required this.title,
    required this.price,
    required this.duration,
    this.numberOfFreezes = 0,
    this.freezeDurationInDays = 0,
  });
}
