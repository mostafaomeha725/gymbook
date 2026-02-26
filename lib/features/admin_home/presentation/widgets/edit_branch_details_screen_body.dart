import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:gymbook/core/routes/route_paths.dart';
import 'package:gymbook/core/widgets/appbar_subscription_widget.dart';
import 'package:gymbook/features/admin_home/data/models/branch_list_model.dart';
import 'package:gymbook/features/admin_home/presentation/widgets/edit_option_tile.dart';

class EditBranchDetailsScreenBody extends StatelessWidget {
  final BranchItem branch;

  const EditBranchDetailsScreenBody({super.key, required this.branch});

  @override
  Widget build(BuildContext context) {
    final options = [
      EditOption(
        icon: Icons.business_outlined,
        iconColor: const Color(0xFF0EA5E9),
        iconBg: const Color(0xFFE0F2FE),
        title: 'Edit Business Details',
        subtitle: 'Update branch name, type, email and phone',
        onTap: () => GoRouter.of(context).push(
          Routes.addBranchOneScreen,
          extra: BranchScreenArgs(
            branchId: branch.id,
            isEditMode: true,
            branch: branch,
          ),
        ),
      ),
      EditOption(
        icon: Icons.location_on_outlined,
        iconColor: const Color(0xFF10B981),
        iconBg: const Color(0xFFD1FAE5),
        title: 'Edit Location Details',
        subtitle: 'Update address, governorate and map location',
        onTap: () => GoRouter.of(context).push(
          Routes.addBranchTwoScreen,
          extra: BranchScreenArgs(
            branchId: branch.id,
            isEditMode: true,
            branch: branch,
          ),
        ),
      ),
      EditOption(
        icon: Icons.access_time_outlined,
        iconColor: const Color(0xFFF59E0B),
        iconBg: const Color(0xFFFEF3C7),
        title: 'Edit Working Hours',
        subtitle: 'Update branch operating hours',
        onTap: () => GoRouter.of(context).push(
          Routes.addBranchThreeScreen,
          extra: BranchScreenArgs(
            branchId: branch.id,
            isEditMode: true,
            branch: branch,
          ),
        ),
      ),
      EditOption(
        icon: Icons.photo_library_outlined,
        iconColor: const Color(0xFF8B5CF6),
        iconBg: const Color(0xFFEDE9FE),
        title: 'Edit Photos',
        subtitle: 'Update branch gallery and images',
        onTap: () => GoRouter.of(context).push(
          '${Routes.addBranchFourScreen}?branchId=${branch.id}&isEditMode=true&imageId=${branch.logoImageId ?? ''}',
        ),
      ),
    ];

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          child: const AppbarSubscriptionWidget(text: 'Edit Branch Details'),
        ),

        SizedBox(height: 24.h),

        Padding(
          padding: EdgeInsets.symmetric(horizontal: 22.w),
          child: Column(
            children: options.map((o) => EditOptionTile(option: o)).toList(),
          ),
        ),
      ],
    );
  }
}
