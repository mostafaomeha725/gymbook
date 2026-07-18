import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:gymbook/core/routes/route_paths.dart';
import 'package:gymbook/core/theme/styles.dart';
import 'package:gymbook/core/widgets/custom_text.dart';
import 'package:gymbook/features/admin/admin_home/domain/entities/branch_entity.dart';
import 'package:gymbook/features/admin/admin_home/presentation/cubits/branches_list_cubit/branches_list_cubit.dart';
import 'package:gymbook/features/admin/admin_home/presentation/widgets/branch_card.dart';

class BranchesListView extends StatelessWidget {
  final List<BranchEntity> branches;
  final bool isFetchingMore;

  const BranchesListView({
    super.key,
    required this.branches,
    this.isFetchingMore = false,
  });

  @override
  Widget build(BuildContext context) {
    if (branches.isEmpty) {
      return SliverToBoxAdapter(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 60.h),
          child: AppText(
            'No branches found.\nTap + to add your first branch.',
            alignment: AlignmentDirectional.center,
            textAlign: TextAlign.center,
            style: font18w500,
          ),
        ),
      );
    }

    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate((context, index) {
          if (index == branches.length) {
            return Padding(
              padding: EdgeInsets.symmetric(vertical: 16.h),
              child: const Center(child: CircularProgressIndicator()),
            );
          }

          final branch = branches[index];
          return Padding(
            padding: EdgeInsets.only(bottom: 12.h),
            child: BranchCard(
              imageUrl: branch.logo,
              branchName: branch.name ?? 'Branch #${branch.id}',
              location: branch.displayLocation,
              tags: [branch.branchTypeName, branch.branchStatusName],
              subscriptions: branch.subscriptionsCount,
              onTap: () async {
                await GoRouter.of(
                  context,
                ).push(Routes.adminBranchScreen, extra: branch);

                if (context.mounted) {
                  context.read<BranchesListCubit>().loadBranches(refresh: true);
                }
              },
            ),
          );
        }, childCount: branches.length + (isFetchingMore ? 1 : 0)),
      ),
    );
  }
}
