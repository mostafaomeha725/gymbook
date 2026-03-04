import 'package:flutter/material.dart';
import 'package:gymbook/features/admin_home/domain/entities/branch_entity.dart';
import 'package:gymbook/features/admin_home/presentation/widgets/edit_branch_details_screen_body.dart';

class EditBranchDetailsScreen extends StatelessWidget {
  final BranchEntity branch;

  const EditBranchDetailsScreen({super.key, required this.branch});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: EditBranchDetailsScreenBody(branch: branch));
  }
}
