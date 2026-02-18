import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gymbook/features/admin_home/presentation/widgets/all_text_field_add_branch_one.dart';
import 'package:gymbook/features/auth/presentation/widgets/appbar_auth_card.dart';

class AddBranchOneScreenBody extends StatelessWidget {
  const AddBranchOneScreenBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: const Column(
          children: [
            AppbarAuthCard(
              title: 'Login',
              subtitle: 'Step 1 of 4: Business Details', // اختياري
              currentStep: 1,
              totalSteps: 4,
            ),
            AllTextFieldAddBranchOne(),
          ],
        ),
      ),
    );
  }
}
