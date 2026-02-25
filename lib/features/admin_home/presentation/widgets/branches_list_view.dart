import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gymbook/core/widgets/custom_text.dart';
import 'package:gymbook/features/admin_home/data/models/branch_list_model.dart';
import 'package:gymbook/features/admin_home/presentation/widgets/branch_card.dart';

class BranchesListView extends StatelessWidget {
  final List<BranchItem> branches;

  const BranchesListView({super.key, required this.branches});

  static const String _placeholderImage =
      'https://images.unsplash.com/photo-1534438327276-14e5300c3a48?w=500&h=300&fit=crop';

  @override
  Widget build(BuildContext context) {
    if (branches.isEmpty) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 60.h),
        child: const Center(
          child: AppText(
            'No branches found.\nTap + to add your first branch.',
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      itemCount: branches.length,
      itemBuilder: (context, index) {
        final branch = branches[index];

        return Padding(
          padding: EdgeInsets.only(bottom: 12.h),
          child: BranchCard(
            imageUrl: branch.logo ?? _placeholderImage,
            branchName: branch.name ?? 'Branch #${branch.id}',
            location: branch.displayLocation,
            tags: [branch.branchTypeName, branch.branchStatusName],
            subscriptions: branch.subscriptionsCount,
            onTap: () {},
          ),
        );
      },
    );
  }
}
