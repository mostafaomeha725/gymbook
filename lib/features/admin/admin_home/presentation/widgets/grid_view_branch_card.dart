import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gymbook/core/di/services_locator.dart';
import 'package:gymbook/features/admin/admin_home/presentation/cubits/branch_reviews/branch_reviews_cubit.dart';
import 'package:gymbook/features/admin/admin_home/presentation/widgets/grid_view_branch_card_content.dart';

class GridViewBranchCard extends StatelessWidget {
  final int branchId;
  final VoidCallback? onRefresh;

  const GridViewBranchCard({super.key, required this.branchId, this.onRefresh});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<BranchReviewsCubit>()..loadReviews(branchId),
      child: GridViewBranchCardContent(
        branchId: branchId,
        onRefresh: onRefresh,
      ),
    );
  }
}
