import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gymbook/core/theme/styles.dart';
import 'package:gymbook/core/widgets/custom_text.dart';

class SubscriptionSessionsProgress extends StatelessWidget {
  final int checkInsCount;
  final int durationInDays;

  const SubscriptionSessionsProgress({
    super.key,
    required this.checkInsCount,
    required this.durationInDays,
  });

  @override
  Widget build(BuildContext context) {
    final safeDuration = durationInDays <= 0 ? 1 : durationInDays;
    final safeCheckIns = checkInsCount.clamp(0, safeDuration);
    final progress = (safeCheckIns / safeDuration).clamp(0.0, 1.0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AppText(
              "Sessions Used",
              style: font16w500.copyWith(color: Colors.grey[700]),
            ),
            AppText(
              '$safeCheckIns/${durationInDays <= 0 ? 0 : durationInDays}',
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
      ],
    );
  }
}
