import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:gymbook/core/routes/route_paths.dart';
import 'package:gymbook/features/admin_home/data/models/branch_list_model.dart';
import 'package:gymbook/features/admin_home/presentation/widgets/all_current_status.dart';
import 'package:gymbook/features/admin_home/presentation/widgets/branch_buttom.dart';
import 'package:gymbook/features/admin_home/presentation/widgets/branch_header_section.dart';
import 'package:gymbook/features/admin_home/presentation/widgets/custom_segmented_tabs.dart';
import 'package:gymbook/features/admin_home/presentation/widgets/grid_view_branch_card.dart';
import 'package:gymbook/features/admin_home/presentation/widgets/grid_view_status_card.dart';

class AdminBranchScreenBody extends StatefulWidget {
  final BranchItem branch;

  const AdminBranchScreenBody({super.key, required this.branch});

  @override
  State<AdminBranchScreenBody> createState() => _AdminBranchScreenBodyState();
}

class _AdminBranchScreenBodyState extends State<AdminBranchScreenBody> {
  int selectedTab = 0;

  final tabs = const ["Today", "This Week", "This Month", "This Year", "All"];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          BranchHeaderSection(branch: widget.branch),
          SizedBox(height: 24.h),

          BranchButtom(
            text: 'Edit Branch Details',
            icon: Icons.arrow_forward,
            onTap: () {
              GoRouter.of(
                context,
              ).push(Routes.editBranchDetailsScreen, extra: widget.branch);
            },
          ),

          SizedBox(height: 16.h),
          GridViewBranchCard(branchId: widget.branch.id),
          SizedBox(height: 24.h),
          const AllCurrentStatus(),
          SizedBox(height: 24.h),

          CustomSegmentedTabs(
            tabs: tabs,
            selectedIndex: selectedTab,
            onChanged: (value) {
              setState(() => selectedTab = value);
            },
          ),

          SizedBox(height: 12.h),
          const GridViewStatusCard(),
          SizedBox(height: 152.h),
        ],
      ),
    );
  }
}
