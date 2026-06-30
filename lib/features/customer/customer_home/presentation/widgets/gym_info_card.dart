import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gymbook/core/theme/styles.dart';
import 'package:gymbook/core/widgets/bouncing_social_button.dart';
import 'package:gymbook/core/widgets/custom_text.dart';
import 'package:gymbook/features/admin/admin_home/presentation/widgets/get_type_color.dart';

class GymInfoCard extends StatelessWidget {
  final String gymName;
  final String address;
  final double rating;
  final int reviewsCount;
  final String type; // mixed | men | women
  final VoidCallback onDirectionsTap;
  final VoidCallback onReviewsTap;

  const GymInfoCard({
    super.key,
    required this.gymName,
    required this.address,
    required this.rating,
    required this.reviewsCount,
    required this.type,
    required this.onDirectionsTap,
    required this.onReviewsTap,
  });
  @override
  Widget build(BuildContext context) {
    final typeColor = GetTypeColor().getTypeColor(type);
    final typeBgColor = GetTypeColor().getBgColor(type);

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
            gymName,
            style: font24w700.copyWith(color: const Color(0xff0F172A)),
          ),

          SizedBox(height: 6.h),

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
                  address,
                  style: font14w400.copyWith(color: const Color(0xff64748B)),
                ),
              ),
            ],
          ),

          SizedBox(height: 10.h),

          /// Rating + Type
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: onReviewsTap,
                borderRadius: BorderRadius.circular(8.r),
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 4.w),
                  child: Row(
                    children: [
                      Icon(
                        Icons.star,
                        size: 16.sp,
                        color: const Color(0xffFACC15),
                      ),
                      SizedBox(width: 4.w),
                      AppText(rating.toString(), style: font14w700),
                      SizedBox(width: 6.w),
                      AppText(
                        '($reviewsCount)',
                        style: font14w400.copyWith(
                          color: const Color(0xff6A7282),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              /// Type Badge
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: typeBgColor,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: AppText(
                  type,
                  style: font12w500.copyWith(color: typeColor),
                ),
              ),
            ],
          ),

          SizedBox(height: 16.h),
          BouncingSocialButton(
            text: 'Directions',
            borderColor: const Color(0XFF0EA5E9),
            icon: Icons.location_on_outlined,
            onTap: onDirectionsTap,
            textSize: 14.sp,
            textColor: const Color(0XFF0EA5E9),
          ),

          // /// Buttons
          // Row(
          //   children: [
          //     Expanded(
          //       child: BouncingSocialButton(
          //         text: 'Directions',
          //         borderColor: const Color(0XFF0EA5E9),
          //         icon: Icons.location_on_outlined,
          //         onTap: onDirectionsTap,
          //         textSize: 14.sp,
          //         textColor: const Color(0XFF0EA5E9),
          //       ),
          //     ),

          //     SizedBox(width: 12.w),

          //     /// View Plans
          //     Expanded(
          //       child: AppButton(
          //         text: 'View Plans',
          //         onPressed: () {},
          //         radius: 14.r,
          //         height: 48.h,
          //         textSize: 14.sp,
          //         textWeight: FontWeight.w600,
          //         gradient: const LinearGradient(
          //           begin: Alignment.topCenter,
          //           end: Alignment.bottomCenter,
          //           colors: [Color(0xff0EA5E9), Color(0xff0284C7)],
          //         ),
          //       ),
          //     ),
          //   ],
          // ),
        ],
      ),
    );
  }
}
