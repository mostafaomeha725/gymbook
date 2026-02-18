import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gymbook/core/theme/styles.dart';
import 'package:gymbook/core/widgets/custom_text.dart';
import 'package:gymbook/features/admin_home/presentation/widgets/admin_subscription_card_info_item.dart';
import 'get_type_color.dart';

class AdminSubscriptionCard extends StatelessWidget {
  const AdminSubscriptionCard({
    super.key,
    required this.name,
    required this.status,
    required this.totalDays,
    required this.remainingDays,
    this.onTap,
  });

  final String name;
  final String status;
  final int totalDays;
  final int remainingDays;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    final colorHelper = GetTypeColor();
    final mainColor = colorHelper.getTypeColor(status);
    final bgColor = colorHelper.getBgColor(status);

    final progress = totalDays == 0
        ? 0.0
        : (remainingDays / totalDays).clamp(0, 1);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 22.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24.r),
          boxShadow: [
            BoxShadow(
              // ignore: deprecated_member_use
              color: Colors.black.withOpacity(.05),
              blurRadius: 20.r,
              offset: const Offset(0, 8),
            ),
          ],
        ),

        child: ClipRRect(
          borderRadius: BorderRadius.circular(24.r),
          child: Stack(
            children: [
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Container(height: 8.h, color: mainColor),
              ),

              Padding(
                padding: EdgeInsets.fromLTRB(20.w, 26.h, 20.w, 20.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(
                      name,
                      style: font22w700.copyWith(
                        color: const Color(0xff334155),
                      ),
                    ),

                    SizedBox(height: 8.h),

                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 14.w,
                            vertical: 6.h,
                          ),
                          decoration: BoxDecoration(
                            color: bgColor,
                            borderRadius: BorderRadius.circular(30.r),
                          ),
                          child: AppText(
                            status,
                            style: font14w700.copyWith(color: mainColor),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 22.h),

                    Row(
                      children: [
                        AdminSubscriptionCardInfoItem(
                          icon: Icons.calendar_month_outlined,
                          title: "Total Duration",
                          value: "$totalDays days",
                        ),
                        const Spacer(),
                        AdminSubscriptionCardInfoItem(
                          icon: Icons.access_time,
                          title: "Remaining",
                          value: "$remainingDays days",
                          valueColor: mainColor,
                        ),
                      ],
                    ),

                    SizedBox(height: 18.h),

                    ClipRRect(
                      borderRadius: BorderRadius.circular(20.r),
                      child: LinearProgressIndicator(
                        value: progress.toDouble(),
                        minHeight: 8.h,
                        backgroundColor: Colors.grey.shade300,
                        valueColor: AlwaysStoppedAnimation(mainColor),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
