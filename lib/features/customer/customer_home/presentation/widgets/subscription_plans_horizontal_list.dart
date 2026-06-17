import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gymbook/core/theme/styles.dart';
import 'package:gymbook/core/widgets/custom_text.dart';
import 'package:gymbook/features/customer/customer_home/presentation/widgets/subscription_plan_card.dart';

class SubscriptionPlansHorizontalList extends StatelessWidget {
  final List<PlanModel> plans;

  const SubscriptionPlansHorizontalList({super.key, required this.plans});

  @override
  Widget build(BuildContext context) {
    if (plans.isEmpty) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 24.h),
        child: Column(
          children: [
            Icon(
              Icons.card_membership_outlined,
              size: 56.sp,
              color: Colors.grey.shade300,
            ),
            SizedBox(height: 12.h),
            AppText(
              'No Plans Available',
              style: font16w600.copyWith(color: const Color(0xff475569)),
              alignment: AlignmentDirectional.center,
            ),
            SizedBox(height: 12.h),
            AppText(
              'This branch does not have any subscription plans yet.',
              style: font14w400.copyWith(color: const Color(0xff94A3B8)),
              maxLines: 2,
              alignment: AlignmentDirectional.center,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

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
