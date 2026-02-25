import 'package:flutter/material.dart';
import 'package:gymbook/features/admin_home/data/models/branch_list_model.dart';
import 'package:gymbook/features/admin_home/presentation/widgets/admin_branch_screen_body.dart';

class AdminBranchScreen extends StatelessWidget {
  final BranchItem branch;

  const AdminBranchScreen({super.key, required this.branch});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: AdminBranchScreenBody(branch: branch));
  }
}
