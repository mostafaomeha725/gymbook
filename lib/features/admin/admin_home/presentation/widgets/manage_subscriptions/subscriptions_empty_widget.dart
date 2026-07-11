import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gymbook/core/theme/styles.dart';
import 'package:gymbook/core/widgets/custom_text.dart';

class SubscriptionsEmptyWidget extends StatelessWidget {
  final bool hasSearch;

  const SubscriptionsEmptyWidget({super.key, required this.hasSearch});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 48.h),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.card_membership_outlined,
              size: 64.sp,
              color: Colors.grey.shade300,
            ),
            SizedBox(height: 16.h),
            AppText(
              'No subscriptions found',
              style: font16w600.copyWith(color: const Color(0xff475569)),
              alignment: AlignmentDirectional.center,
            ),
            SizedBox(height: 8.h),
            AppText(
              hasSearch
                  ? 'No subscriptions match your search.'
                  : 'No subscriptions found for this status.',
              style: font14w400.copyWith(color: const Color(0xff94A3B8)),
              alignment: AlignmentDirectional.center,
            ),
          ],
        ),
      ),
    );
  }
}
