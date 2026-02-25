import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gymbook/features/admin_home/data/models/branch_list_model.dart';
import 'package:gymbook/features/admin_home/presentation/widgets/all_text_field_add_branch_two.dart';
import 'package:gymbook/features/auth/presentation/widgets/appbar_auth_card.dart';

class AddBranchTwoScreenBody extends StatelessWidget {
  final int branchId;
  final BranchScreenArgs? args;

  const AddBranchTwoScreenBody({super.key, this.branchId = 0, this.args});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          children: [
            AppbarAuthCard(
              title: args?.isEditMode == true ? 'Edit Branch' : 'Add Branch',
              subtitle: 'Step 2 of 4: Location Details',
              currentStep: 2,
              totalSteps: 4,
            ),
            AllTextFieldAddBranchTwo(branchId: branchId, args: args),
          ],
        ),
      ),
    );
  }
}
