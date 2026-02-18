import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gymbook/features/admin_home/presentation/widgets/status_card.dart';

class ManagePackageStatus extends StatelessWidget {
  const ManagePackageStatus({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 22.w),
      child: Row(
        children: [
          const Expanded(
            child: StatusCard(
              icon: Icons.inventory_2_outlined,
              title: "5",

              subtitle: "Total",
              isCenter: true,
              gradient: LinearGradient(
                colors: [Color(0xFF8B5CF6), Color(0xFF6D28D9)],
              ),
            ),
          ),
          SizedBox(width: 12.w),
          const Expanded(
            child: StatusCard(
              icon: Icons.trending_up,
              title: "3",
              subtitle: "Active",
              isCenter: true,
              gradient: LinearGradient(
                colors: [Color(0xFF10B981), Color(0xFF059669)],
              ),
            ),
          ),
          SizedBox(width: 12.w),
          const Expanded(
            child: StatusCard(
              icon: Icons.attach_money,
              title: "1850",
              subtitle: "Avg. Price",
              isCenter: true,
              gradient: LinearGradient(
                colors: [Color(0xFFF59E0B), Color(0xFFD97706)],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
