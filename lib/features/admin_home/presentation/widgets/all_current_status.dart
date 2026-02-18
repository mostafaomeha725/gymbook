import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gymbook/core/theme/styles.dart';
import 'package:gymbook/core/widgets/custom_text.dart';
import 'package:gymbook/features/admin_home/presentation/widgets/status_card.dart';

class AllCurrentStatus extends StatelessWidget {
  const AllCurrentStatus({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 22.w),
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: AppText(
              "Current Status",
              style: font20w700.copyWith(color: const Color(0xff2C3E50)),
            ),
          ),

          SizedBox(height: 16.h),

          Row(
            children: [
              const Expanded(
                child: StatusCard(
                  icon: Icons.person_outline,
                  title: "145",
                  subtitle: "Active Now",
                  iconColor: Color(0xFF0EA5E9),
                ),
              ),
              SizedBox(width: 12.w),
              const Expanded(
                child: StatusCard(
                  icon: Icons.inventory_2_outlined,
                  title: "8",
                  subtitle: "Packages",
                  iconColor: Color(0xFFF59E0B),
                ),
              ),
              SizedBox(width: 12.w),
              const Expanded(
                child: StatusCard(
                  icon: Icons.meeting_room_outlined,
                  title: "Open",
                  subtitle: "Status",
                  iconColor: Color(0xFF10B981),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
