import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gymbook/core/theme/styles.dart';
import 'package:gymbook/core/widgets/custom_text.dart';
import 'package:gymbook/features/auth/presentation/screens/widgets/bouncing_social_button.dart';

class SubscriptionsInfoCard extends StatelessWidget {
  const SubscriptionsInfoCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      margin: EdgeInsets.symmetric(horizontal: 24.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20.r,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Gym Name
          AppText(
            'PowerHouse Gym',
            style: font24w700.copyWith(color: const Color(0xff0F172A)),
          ),

          SizedBox(height: 8.h),

          /// Address
          Row(
            children: [
              const Icon(
                Icons.location_on_outlined,
                size: 16,
                color: Color(0xff0EA5E9),
              ),
              SizedBox(width: 4.w),
              Expanded(
                child: AppText(
                  '123 Fitness Street, Nasr City, Cairo',
                  style: font14w400.copyWith(color: const Color(0xff64748B)),
                ),
              ),
            ],
          ),
          SizedBox(height: 6.h),

          Row(
            children: [
              const Icon(
                Icons.schedule_outlined,
                size: 16,
                color: Color(0xff0EA5E9),
              ),
              SizedBox(width: 4.w),
              Expanded(
                child: AppText(
                  'Open until 11:00 PM',
                  style: font14w400.copyWith(color: const Color(0xff64748B)),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),

          BouncingSocialButton(
            text: 'View on Google Maps',
            borderColor: const Color(0XFF0EA5E9),
            icon: Icons.location_on_outlined,
            onTap: () {
              // Directions action
            },
            textSize: 14.sp,

            textColor: const Color(0XFF0EA5E9),
          ),
        ],
      ),
    );
  }
}
