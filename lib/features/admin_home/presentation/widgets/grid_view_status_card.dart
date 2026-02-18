import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gymbook/features/admin_home/presentation/widgets/status_card.dart';

class GridViewStatusCard extends StatelessWidget {
  const GridViewStatusCard({super.key});

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
        StatusCard(
          icon: Icons.person_add_alt,
          title: "3",
          subtitle: "New Subscriptions",
          iconColor: Color(0xFFF59E0B),
        ),
        StatusCard(
          icon: Icons.attach_money,
          title: "4,800",
          subtitle: "Revenue (EGP)",
          iconColor: Color(0xFF10B981),
        ),
        StatusCard(
          icon: Icons.check_circle_outline,
          title: "87",
          subtitle: "Check-ins Count",
          iconColor: Color(0xFF0EA5E9),
        ),
        StatusCard(
          icon: Icons.event_busy_outlined,
          title: "1",
          subtitle: "Expired Subscriptions",
          iconColor: Color(0xFFEF4444),
        ),
      ],
    );
  }
}
