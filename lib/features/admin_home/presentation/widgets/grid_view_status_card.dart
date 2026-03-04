import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gymbook/features/admin_home/presentation/cubits/branch_statistics_cubit/branch_statistics_cubit.dart';
import 'package:gymbook/features/admin_home/presentation/widgets/status_card.dart';

class GridViewStatusCard extends StatelessWidget {
  const GridViewStatusCard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BranchStatisticsCubit, BranchStatisticsState>(
      builder: (context, state) {
        final stats = state is BranchStatisticsSuccess
            ? state.statistics
            : null;
        final isLoading = state is BranchStatisticsLoading;

        return GridView.count(
          padding: EdgeInsets.symmetric(horizontal: 22.w),
          crossAxisCount: 2,
          crossAxisSpacing: 16.w,
          mainAxisSpacing: 16.h,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          childAspectRatio: 1.2,
          children: [
            StatusCard(
              icon: Icons.person_add_alt,
              title: isLoading ? '...' : '${stats?.newSubscriptionsCount ?? 0}',
              subtitle: 'New Subscriptions',
              iconColor: const Color(0xFFF59E0B),
            ),
            StatusCard(
              icon: Icons.attach_money,
              title: isLoading
                  ? '...'
                  : _formatRevenue(stats?.totalRevenue ?? 0),
              subtitle: 'Revenue (EGP)',
              iconColor: const Color(0xFF10B981),
            ),
            StatusCard(
              icon: Icons.check_circle_outline,
              title: isLoading ? '...' : '${stats?.checkInsCount ?? 0}',
              subtitle: 'Check-ins Count',
              iconColor: const Color(0xFF0EA5E9),
            ),
            StatusCard(
              icon: Icons.event_busy_outlined,
              title: isLoading
                  ? '...'
                  : '${stats?.expiredSubscriptionsCount ?? 0}',
              subtitle: 'Expired Subscriptions',
              iconColor: const Color(0xFFEF4444),
            ),
          ],
        );
      },
    );
  }

  String _formatRevenue(double value) {
    if (value >= 1000000) return '${(value / 1000000).toStringAsFixed(1)}M';
    if (value >= 1000) return '${(value / 1000).toStringAsFixed(1)}K';
    final hasFraction = value % 1 != 0;
    return hasFraction ? value.toStringAsFixed(2) : value.toStringAsFixed(0);
  }
}
