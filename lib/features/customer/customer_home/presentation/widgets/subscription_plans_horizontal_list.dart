import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gymbook/features/customer/customer_home/presentation/widgets/subscription_plan_card.dart';

class SubscriptionPlansHorizontalList extends StatelessWidget {
  final List<PlanModel> plans;

  const SubscriptionPlansHorizontalList({super.key, required this.plans});

  @override
  Widget build(BuildContext context) {
    final effectivePlans = plans.isEmpty
        ? const [
            PlanModel(title: 'No plans available', price: 0, duration: '-'),
          ]
        : plans;

    return SizedBox(
      height: 210.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        itemBuilder: (context, index) {
          return SubscriptionPlanCard(plan: effectivePlans[index]);
        },
        separatorBuilder: (_, __) => SizedBox(width: 16.w),
        itemCount: effectivePlans.length,
      ),
    );
  }
}
