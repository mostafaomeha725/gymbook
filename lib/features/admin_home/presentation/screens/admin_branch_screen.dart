import 'package:flutter/material.dart';
import 'package:gymbook/features/admin_home/domain/entities/branch_entity.dart';
import 'package:gymbook/features/admin_home/presentation/widgets/admin_branch_screen_body.dart';

class AdminBranchScreen extends StatelessWidget {
  final BranchEntity branch;

  const AdminBranchScreen({super.key, required this.branch});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: AdminBranchScreenBody(branch: branch));
  }
}
