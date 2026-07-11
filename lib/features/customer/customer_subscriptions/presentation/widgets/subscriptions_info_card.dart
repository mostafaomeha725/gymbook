import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gymbook/core/theme/styles.dart';
import 'package:gymbook/core/widgets/bouncing_social_button.dart';
import 'package:gymbook/core/widgets/custom_text.dart';
import 'package:gymbook/features/admin/admin_home/presentation/widgets/get_type_color.dart';

class SubscriptionsInfoCard extends StatelessWidget {
  final String gymName;
  final String address;
  final int status;
  final VoidCallback onViewOnMapTap;
  final VoidCallback onGymDetailsTap;

  const SubscriptionsInfoCard({
    super.key,
    required this.gymName,
    required this.address,
    required this.status,
    required this.onViewOnMapTap,
    required this.onGymDetailsTap,
  });

  @override
  Widget build(BuildContext context) {
    final typeColorHelper = GetTypeColor();
    final statusText = typeColorHelper.getSubscriptionStatusText(status);
    final statusColor = typeColorHelper.getSubscriptionStatusColor(status);
    final statusBgColor = typeColorHelper.getSubscriptionStatusBgColor(status);

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
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: AppText(
                  gymName,
                  style: font24w700.copyWith(color: const Color(0xff0F172A)),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: statusBgColor,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: AppText(
                  statusText,
                  style: font12w500.copyWith(color: statusColor),
                ),
              ),
            ],
          ),

          SizedBox(height: 8.h),

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
          SizedBox(height: 16.h),

          Row(
            children: [
              Expanded(
                child: BouncingSocialButton(
                  text: 'Gym Details',
                  borderColor: const Color(0XFF0EA5E9),
                  icon: Icons.storefront_outlined,
                  onTap: onGymDetailsTap,
                  textSize: 14.sp,
                  textColor: const Color(0XFF0EA5E9),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: BouncingSocialButton(
                  text: 'Maps',
                  borderColor: const Color(0XFF0EA5E9),
                  icon: Icons.location_on_outlined,
                  onTap: onViewOnMapTap,
                  textSize: 14.sp,
                  textColor: const Color(0XFF0EA5E9),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
