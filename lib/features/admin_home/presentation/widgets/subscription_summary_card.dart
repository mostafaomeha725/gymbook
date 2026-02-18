import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gymbook/core/widgets/custom_text.dart';
import 'package:gymbook/core/theme/styles.dart';

class SubscriptionSummaryCard extends StatelessWidget {
  const SubscriptionSummaryCard({
    super.key,
    required this.planName,
    required this.price,
  });

  final String planName;
  final String price;

  @override
  Widget build(BuildContext context) {
    const mainColor = Color(0xFF0EA5E9);

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 22.w),
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22.r),

        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [mainColor.withAlpha(20), mainColor.withAlpha(5)],
        ),

        border: Border.all(color: mainColor.withAlpha(89), width: 1.5.w),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText("Summary", style: font18w700.copyWith(color: mainColor)),

          SizedBox(height: 14.h),

          Row(
            children: [
              Expanded(
                child: AppText(
                  planName,
                  style: font18w700.copyWith(color: const Color(0xff334155)),
                ),
              ),

              AppText(
                "$price EGP",
                style: font22w700.copyWith(color: mainColor),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
