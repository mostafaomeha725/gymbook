import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gymbook/core/constants/app_assets.dart';

import 'package:gymbook/features/home/presentation/screens/widgets/attendance_history_card.dart';
import 'package:gymbook/features/home/presentation/screens/widgets/image_gym_details.dart';
import 'package:gymbook/features/home/presentation/screens/widgets/rating_card.dart';
import 'package:gymbook/features/home/presentation/screens/widgets/subscriptions_details_info_card.dart';
import 'package:gymbook/features/home/presentation/screens/widgets/subscriptions_info_card.dart';

class SubscriptionsDetailsScreenBody extends StatelessWidget {
  const SubscriptionsDetailsScreenBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const ImageGymDetails(
            images: [Assets.gym3, Assets.gym2, Assets.gym3],
          ),
          SizedBox(height: 16.h),
          const SubscriptionsInfoCard(),
          SizedBox(height: 16.h),
          const SubscriptionsDetailsInfoCard(),
          SizedBox(height: 16.h),

          const AttendanceHistoryCard(),
          SizedBox(height: 16.h),
          const RatingCard(),
          SizedBox(height: 64.h),
        ],
      ),
    );
  }
}
