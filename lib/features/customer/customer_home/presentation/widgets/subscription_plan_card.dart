import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gymbook/core/theme/styles.dart';
import 'package:gymbook/core/widgets/custom_button.dart';
import 'package:gymbook/core/widgets/custom_text.dart';

class SubscriptionPlanCard extends StatelessWidget {
  final PlanModel plan;

  const SubscriptionPlanCard({super.key, required this.plan});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220.w,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xff0EA5E9), Color(0xff0284C7)],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 12,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Title
          AppText(plan.title, style: font18w700.copyWith(color: Colors.white)),

          SizedBox(height: 12.h),

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

          /// Duration
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: AppText(
              plan.duration,
              style: font14w400.copyWith(color: Colors.white.withOpacity(0.9)),
            ),
          ),

          const Spacer(),

          AppButton(
            text: 'Subscribe',
            onPressed: () {},
            color: Colors.white,
            textColor: const Color(0xff0EA5E9),
          ),
        ],
      ),
    );
  }
}

class PlanModel {
  final String title;
  final double price;
  final String duration;

  const PlanModel({
    required this.title,
    required this.price,
    required this.duration,
  });
}
