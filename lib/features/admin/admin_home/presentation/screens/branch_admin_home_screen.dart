import 'package:flutter/material.dart';
import 'package:gymbook/core/di/services_locator.dart';
import 'package:gymbook/core/services/user_role_service.dart';
import 'package:gymbook/features/admin/admin_home/domain/entities/branch_entity.dart';
import 'package:gymbook/features/admin/admin_home/presentation/screens/admin_branch_screen.dart';

class BranchAdminHomeScreen extends StatelessWidget {
  const BranchAdminHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final roleService = sl<UserRoleService>();
    final branchId = roleService.getBranchId() ?? 0;
    final branchName = roleService.getBranchName() ?? 'Branch';

    final dummyBranch = BranchEntity(
      id: branchId,
      name: branchName,
      branchType: 2, // Default
      branchStatus: 1, // Default Active
      subscriptionsCount: 0,
    );

    return AdminBranchScreen(branch: dummyBranch);
  }
}
