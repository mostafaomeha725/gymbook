import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gymbook/core/theme/styles.dart';
import 'package:gymbook/core/widgets/custom_text.dart';
import 'package:gymbook/core/widgets/appbar_subscription_widget.dart';
import 'package:gymbook/features/admin/admin_home/domain/entities/branch_statistics_entity.dart';
import 'package:gymbook/features/admin/admin_home/presentation/cubits/branch_statistics_cubit/branch_statistics_cubit.dart';
import 'package:gymbook/features/admin/admin_home/presentation/widgets/custom_segmented_tabs.dart';
import 'package:gymbook/features/admin/admin_home/presentation/widgets/grid_view_status_card.dart';

class AdminPerformanceScreenBody extends StatefulWidget {
  const AdminPerformanceScreenBody({super.key});

  @override
  State<AdminPerformanceScreenBody> createState() =>
      _AdminPerformanceScreenBodyState();
}

class _AdminPerformanceScreenBodyState
    extends State<AdminPerformanceScreenBody> {
  int _selectedTabIndex = 0;
  final List<String> _tabs = ['Today', 'This Week', 'This Month', 'All'];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    final period = StatisticsTimePeriod.values[_selectedTabIndex];
    context.read<BranchStatisticsCubit>().loadStatistics(
      branchId: 0,
      timePeriod: period,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 18.w),
            child: const AppbarSubscriptionWidget(
              text: "Overall Performance",
              subtitle: "Combined metrics from all branches",
              showBackButton: false,
            ),
          ),
          SizedBox(height: 24.h),
          CustomSegmentedTabs(
            tabs: _tabs,
            selectedIndex: _selectedTabIndex,
            onChanged: (index) {
              setState(() {
                _selectedTabIndex = index;
              });
              _loadData();
            },
            titlePrefix: "Period Metrics",
            titleBuilder: (tab) => "Period Metrics ($tab)",
          ),
          SizedBox(height: 16.h),
          const GridViewStatusCard(showCheckIns: false),
          SizedBox(height: 24.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 22.w),
            child: Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: const Color(0xFFF0F9FF),
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: const Color(0xFFE0F2FE)),
              ),
              child: AppText(
                "Note: These metrics are calculated across all your branches combined. Use the filter buttons above to view different time periods.",
                maxLines: 5,
                style: font14w500.copyWith(color: const Color(0xFF0369A1)),
              ),
            ),
          ),
          SizedBox(height: 152.h),
        ],
      ),
    );
  }
}
