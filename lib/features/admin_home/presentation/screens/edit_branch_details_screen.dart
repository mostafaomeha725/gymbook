import 'package:flutter/material.dart';
import 'package:gymbook/features/admin_home/data/models/branch_list_model.dart';
import 'package:gymbook/features/admin_home/presentation/widgets/edit_branch_details_screen_body.dart';

class EditBranchDetailsScreen extends StatelessWidget {
  final BranchItem branch;

  const EditBranchDetailsScreen({super.key, required this.branch});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: EditBranchDetailsScreenBody(branch: branch));
  }
}
