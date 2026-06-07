import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:gymbook/core/routes/route_paths.dart';
import 'package:gymbook/features/admin/admin_home/presentation/widgets/admin_branch_card.dart';

class GridViewBranchCard extends StatelessWidget {
  final int branchId;
  final VoidCallback? onRefresh;

  const GridViewBranchCard({super.key, required this.branchId, this.onRefresh});

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
      children: [
        AdminBranchCard(
          hasStatus: true,
          title: 'Packages',
          subtitle: 'Manage plans',
          icon: Icons.inventory_2_outlined,
          gradient: const LinearGradient(
            colors: [Color(0xFFFF8A00), Color(0xFFFF5E00)],
          ),
          onTap: () async {
            await GoRouter.of(
              context,
            ).push(Routes.managePackageScreen, extra: branchId);
            onRefresh?.call();
          },
        ),

        AdminBranchCard(
          hasStatus: true,
          title: 'Subscriptions',
          subtitle: 'Manage members',
          icon: Icons.person_add_alt_1,
          gradient: const LinearGradient(
            colors: [Color(0xFF34D399), Color(0xFF059669)],
          ),
          onTap: () async {
            await GoRouter.of(
              context,
            ).push(Routes.adminManageSubscriptionsScreen, extra: branchId);
            onRefresh?.call();
          },
        ),

        AdminBranchCard(
          hasStatus: true,
          title: 'Employees',
          subtitle: 'Manage staff',
          icon: Icons.people_outline,
          gradient: const LinearGradient(
            colors: [Color(0xFFA78BFA), Color(0xFF7C3AED)],
          ),
          onTap: () {
            GoRouter.of(
              context,
            ).push(Routes.adminEmployeesScreen, extra: branchId);
          },
        ),

        AdminBranchCard(
          hasStatus: true,
          title: 'Reviews ⭐ 4.5',
          subtitle: '89 reviews',
          icon: Icons.chat_bubble_outline,
          gradient: const LinearGradient(
            colors: [Color(0xFFFBBF24), Color(0xFFF59E0B)],
          ),
          onTap: () {
            GoRouter.of(
              context,
            ).push(Routes.adminBranchReviewsScreen, extra: branchId);
          },
        ),
      ],
    );
  }
}
