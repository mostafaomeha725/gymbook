import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gymbook/features/admin_home/presentation/screens/widgets/admin_branch_card.dart';

class GridViewBranchCard extends StatelessWidget {
  const GridViewBranchCard({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      padding: EdgeInsets.symmetric(horizontal: 22.w),
      crossAxisCount: 2,
      crossAxisSpacing: 16.w,
      mainAxisSpacing: 16.h,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: 1.2,
      children: const [
        AdminBranchCard(
          title: 'Packages',
          subtitle: 'Manage plans',
          icon: Icons.inventory_2_outlined,
          gradient: LinearGradient(
            colors: [Color(0xFFFF8A00), Color(0xFFFF5E00)],
          ),
        ),

        AdminBranchCard(
          title: 'Subscriptions',
          subtitle: 'Manage members',
          icon: Icons.person_add_alt_1,
          gradient: LinearGradient(
            colors: [Color(0xFF34D399), Color(0xFF059669)],
          ),
        ),

        AdminBranchCard(
          title: 'Hours',
          subtitle: 'Set schedule',
          icon: Icons.access_time,
          gradient: LinearGradient(
            colors: [Color(0xFFA78BFA), Color(0xFF7C3AED)],
          ),
        ),

        AdminBranchCard(
          title: 'Reviews ⭐ 4.5',
          subtitle: '89 reviews',
          icon: Icons.chat_bubble_outline,
          gradient: LinearGradient(
            colors: [Color(0xFFFBBF24), Color(0xFFF59E0B)],
          ),
        ),
      ],
    );
  }
}
