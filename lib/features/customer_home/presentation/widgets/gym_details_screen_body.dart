import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gymbook/core/constants/app_assets.dart';
import 'package:gymbook/core/theme/styles.dart';
import 'package:gymbook/core/widgets/custom_text.dart';
import 'package:gymbook/features/home/presentation/widgets/amenities_card.dart';
import 'package:gymbook/features/home/presentation/widgets/gym_info_card.dart';
import 'package:gymbook/features/home/presentation/widgets/image_gym_details.dart';
import 'package:gymbook/features/home/presentation/widgets/opening_hours_card.dart';
import 'package:gymbook/features/home/presentation/widgets/subscription_plans_horizontal_list.dart';

class GymDetailsScreenBody extends StatelessWidget {
  final GymDetailsArgs args;

  const GymDetailsScreenBody({super.key, required this.args});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const ImageGymDetails(
            images: [Assets.gym3, Assets.gym2, Assets.gym3],
          ),
          SizedBox(height: 16.h),
          GymInfoCard(
            gymName: args.gymName,
            rating: args.rating,
            reviewsCount: args.reviewsCount,
            type: args.type,
            address: '123 Fitness Street, Gym City',
          ),
          SizedBox(height: 16.h),

          const OpeningHoursCard(),
          SizedBox(height: 16.h),

          const AmenitiesCard(),
          SizedBox(height: 16.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: AppText(
              'Membership Plans',
              style: font18w700.copyWith(color: const Color(0xff2C3E50)),
            ),
          ),
          SizedBox(height: 16.h),
          const SubscriptionPlansHorizontalList(),
          SizedBox(height: 32.h),
        ],
      ),
    );
  }
}

class GymDetailsArgs {
  final String gymName;
  final double rating;
  final int reviewsCount;
  final String type;

  const GymDetailsArgs({
    required this.gymName,
    required this.rating,
    required this.reviewsCount,
    required this.type,
  });
}
