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
      padding: EdgeInsets.only(bottom: 124.h, left: 12.w, right: 12.w),
      itemCount: branches.length,
      itemBuilder: (context, index) {
        final branch = branches[index];
        return BranchCard(
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
        );
      },
    );
  }
}
