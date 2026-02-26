import 'package:flutter/material.dart';
import 'package:gymbook/features/admin_home/presentation/widgets/add_branch_four_screen_body.dart';

class AddBranchFourScreen extends StatelessWidget {
  final int branchId;
  final bool isEditMode;
  final int? imageId;

  const AddBranchFourScreen({
    super.key,
    this.branchId = 0,
    this.isEditMode = false,
    this.imageId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AddBranchFourScreenBody(
        branchId: branchId,
        isEditMode: isEditMode,
        imageId: imageId,
      ),
    );
  }
}
