import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gymbook/core/di/services_locator.dart';
import 'package:gymbook/features/admin/admin_home/presentation/cubits/branch_reviews/branch_reviews_cubit.dart';
import 'package:gymbook/features/admin/admin_home/presentation/widgets/admin_branch_reviews_body.dart';

class AdminBranchReviewsScreen extends StatelessWidget {
  final int branchId;
  final String? branchName;

  const AdminBranchReviewsScreen({super.key, required this.branchId, this.branchName});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<BranchReviewsCubit>(),
      child: Scaffold(
        backgroundColor: const Color(0xFFF8FAFC),
        body: AdminBranchReviewsBody(branchId: branchId, branchName: branchName),
      ),
    );
  }
}
