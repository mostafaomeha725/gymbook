import 'package:flutter/material.dart';
import 'package:gymbook/features/admin/admin_home/presentation/widgets/admin_branch_reviews_body.dart';

class AdminBranchReviewsScreen extends StatelessWidget {
  final int branchId;

  const AdminBranchReviewsScreen({super.key, required this.branchId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: AdminBranchReviewsBody(branchId: branchId),
    );
  }
}
