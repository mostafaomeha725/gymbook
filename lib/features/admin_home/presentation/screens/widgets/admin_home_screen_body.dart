import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gymbook/core/theme/styles.dart';
import 'package:gymbook/core/widgets/custom_text.dart';
import 'package:gymbook/features/admin_home/presentation/screens/widgets/branch_data.dart';
import 'package:gymbook/features/admin_home/presentation/screens/widgets/branches_list_view.dart';
import 'package:gymbook/features/home/presentation/screens/widgets/appbar_admin_home_widget.dart';

class AdminHomeScreenBody extends StatelessWidget {
  const AdminHomeScreenBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            children: [
              const AppbarAdminHomeWidget(
                userName: 'My Branches',
                location: 'Manage all your gym locations',
              ),
              SizedBox(height: 16.h),
              AppText(
                'All Branches (${branchesList.length})',
                style: font20w700,
                textPadding: EdgeInsets.symmetric(horizontal: 16.w),
              ),
              SizedBox(height: 16.h),
            ],
          ),
        ),
        const Expanded(child: BranchesListView()),
      ],
    );
  }
}
