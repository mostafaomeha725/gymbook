import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gymbook/features/admin/admin_home/presentation/widgets/admin_branch_card.dart';

class GridViewManageSubscriptions extends StatelessWidget {
  const GridViewManageSubscriptions({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      padding: EdgeInsets.symmetric(horizontal: 22.w),
      crossAxisCount: 2,
      crossAxisSpacing: 16.w,
      mainAxisSpacing: 16.h,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: 1.4.h,
      children: const [
        /// 🟢 Active
        AdminBranchCard(
          title: '4',
          subtitle: 'Active Subscriptions',
          icon: Icons.people_outline,
          hasStatus: false,
          statusText: 'Active',
          gradient: LinearGradient(
            colors: [Color(0xFF34D399), Color(0xFF059669)],
          ),
        ),

        /// 🟠 Expiring Soon
        AdminBranchCard(
          title: '1',
          subtitle: 'Expiring Soon',
          icon: Icons.error_outline,
          hasStatus: false,
          statusText: '≤ 7 days',
          gradient: LinearGradient(
            colors: [Color(0xFFFFA726), Color(0xFFEF6C00)],
          ),
        ),

        /// 🔴 Expired
        AdminBranchCard(
          title: '2',
          subtitle: 'Expired',
          icon: Icons.calendar_today_outlined,
          hasStatus: false,
          statusText: '0 days',
          gradient: LinearGradient(
            colors: [Color(0xFFEF5350), Color(0xFFD32F2F)],
          ),
        ),

        /// 🔵 Freezed
        AdminBranchCard(
          title: '1',
          subtitle: 'Freezed',
          icon: Icons.ac_unit,
          hasStatus: false,
          statusText: 'Paused',
          gradient: LinearGradient(
            colors: [Color(0xFF60A5FA), Color(0xFF2563EB)],
          ),
        ),
      ],
    );
  }
}
