import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gymbook/features/admin_home/presentation/screens/widgets/branch_card.dart';
import 'package:gymbook/features/admin_home/presentation/screens/widgets/branch_data.dart';

class BranchesListView extends StatelessWidget {
  final List<BranchData> branches;

  const BranchesListView({super.key, this.branches = branchesList});

  @override
  Widget build(BuildContext context) {
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
            imageUrl: branch.imageUrl,
            branchName: branch.branchName,
            location: branch.location,
            tags: branch.tags,
            subscriptions: branch.subscriptions,
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('${branch.branchName} tapped!')),
              );
            },
          ),
        );
      },
    );
  }
}
