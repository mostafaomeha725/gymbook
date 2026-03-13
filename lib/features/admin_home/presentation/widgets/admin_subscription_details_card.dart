import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gymbook/features/admin_home/presentation/widgets/content_admin_subscription_details_card.dart';

import 'get_type_color.dart';

class AdminSubscriptionDetailsCard extends StatelessWidget {
  const AdminSubscriptionDetailsCard({
    super.key,
    required this.name,
    required this.plan,
    required this.price,
    required this.status,
    required this.remaining,
    required this.total,
  });

  final String name;
  final String plan;
  final String price;
  final String status;
  final int remaining;
  final int total;

  @override
  Widget build(BuildContext context) {
    final colorHelper = GetTypeColor();
    final mainColor = colorHelper.getTypeColor(status);

    final progress = total == 0 ? 0.0 : (remaining / total).clamp(0.0, 1.0);

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 22.w, vertical: 10.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(26.r),

        gradient: LinearGradient(
          colors: [mainColor, mainColor.withValues(alpha: 0.8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),

        boxShadow: [
          BoxShadow(
            color: mainColor.withValues(alpha: 0.3),
            blurRadius: 20.r,
            offset: const Offset(0, 10),
          ),
        ],
      ),

      child: Stack(
        children: [
          Positioned(
            right: -40.w,
            top: -40.h,
            child: Container(
              width: 160.w,
              height: 160.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.15),
              ),
            ),
          ),

          Positioned(
            left: -50.w,
            bottom: -50.h,
            child: Container(
              width: 160.w,
              height: 160.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.1),
              ),
            ),
          ),

          ContentAdminSubscriptionDetailsCard(
            name: name,
            plan: plan,
            price: price,
            status: status,
            remaining: remaining,
            total: total,
            progress: progress,
          ),
        ],
      ),
    );
  }
}
