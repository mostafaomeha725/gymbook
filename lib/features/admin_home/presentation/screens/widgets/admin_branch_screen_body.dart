import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:gymbook/features/admin_home/presentation/screens/widgets/all_current_status.dart';
import 'package:gymbook/features/admin_home/presentation/screens/widgets/branch_buttom.dart';
import 'package:gymbook/features/admin_home/presentation/screens/widgets/branch_header_section.dart';
import 'package:gymbook/features/admin_home/presentation/screens/widgets/custom_segmented_tabs.dart';
import 'package:gymbook/features/admin_home/presentation/screens/widgets/grid_view_branch_card.dart';

class AdminBranchScreenBody extends StatelessWidget {
  const AdminBranchScreenBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const BranchHeaderSection(),
          SizedBox(height: 24.h),
          BranchButtom(
            text: 'Edit Branch Details',
            icon: Icons.arrow_forward,
            onTap: () {},
          ),
          SizedBox(height: 16.h),

          const GridViewBranchCard(),
          SizedBox(height: 24.h),
          const AllCurrentStatus(),
          SizedBox(height: 24.h),

          const CustomSegmentedTabs(),

          SizedBox(height: 152.h),
        ],
      ),
    );
  }
}
