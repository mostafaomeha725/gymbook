import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gymbook/features/home/presentation/widgets/subscription_plan_card.dart';

class SubscriptionPlansHorizontalList extends StatelessWidget {
  const SubscriptionPlansHorizontalList({super.key});

  @override
  Widget build(BuildContext context) {
    List plans = const [
      PlanModel(title: 'Monthly', price: 500, duration: '30 days'),
      PlanModel(title: 'Weekly', price: 150, duration: '7 days'),
      PlanModel(title: 'Monthly', price: 500, duration: '30 days'),
    ];

    return SizedBox(
      height: 210.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        itemBuilder: (context, index) {
          return SubscriptionPlanCard(plan: plans[index]);
        },
        separatorBuilder: (_, __) => SizedBox(width: 16.w),
        itemCount: plans.length,
      ),
    );
  }
}
