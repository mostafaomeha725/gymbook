import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gymbook/core/theme/styles.dart';
import 'package:gymbook/core/widgets/custom_text.dart';
import 'customer_info_item.dart';

class CustomerDetailsCard extends StatelessWidget {
  const CustomerDetailsCard({
    super.key,
    required this.name,
    required this.email,
    required this.phone,
  });

  final String name;
  final String email;
  final String phone;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 22.w, vertical: 12.h),
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 70.w,
                height: 70.w,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF1D9BF0), Color(0xFF0EA5E9)],
                  ),
                  borderRadius: BorderRadius.circular(22.r),
                ),
                child: Icon(
                  Icons.person_outline,
                  color: Colors.white,
                  size: 32.sp,
                ),
              ),

              SizedBox(width: 16.w),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(
                    "Customer Details",
                    style: font20w700.copyWith(color: const Color(0xff334155)),
                  ),
                  SizedBox(height: 4.h),
                  AppText(
                    "Contact Information",
                    style: font14w500.copyWith(color: const Color(0xff6B7280)),
                  ),
                ],
              ),
            ],
          ),

          SizedBox(height: 20.h),

          CustomerInfoItem(
            icon: Icons.person_outline,
            title: "Full Name",
            value: name,
          ),
          CustomerInfoItem(
            icon: Icons.mail_outline,
            title: "Email Address",
            value: email,
          ),
          CustomerInfoItem(
            iconWidget: Text('🇪🇬', style: TextStyle(fontSize: 16.sp)),
            title: "Phone Number",
            value: phone,
          ),
        ],
      ),
    );
  }
}
