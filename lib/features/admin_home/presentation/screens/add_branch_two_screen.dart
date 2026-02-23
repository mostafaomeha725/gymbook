import 'package:flutter/material.dart';
import 'package:gymbook/features/admin_home/presentation/widgets/add_branch_two_screen_body.dart';

class AddBranchTwoScreen extends StatelessWidget {
  final int branchId;

  const AddBranchTwoScreen({super.key, this.branchId = 0});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: AddBranchTwoScreenBody(branchId: branchId));
  }
}
