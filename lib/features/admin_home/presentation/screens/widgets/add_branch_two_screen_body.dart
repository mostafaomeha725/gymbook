import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gymbook/features/admin_home/presentation/screens/widgets/all_text_field_add_branch_two.dart';
import 'package:gymbook/features/auth/presentation/screens/widgets/appbar_auth_card.dart';

class AddBranchTwoScreenBody extends StatelessWidget {
  const AddBranchTwoScreenBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: const Column(
          children: [
            AppbarAuthCard(
              title: 'Login',
              subtitle: 'Step 2 of 4: Location Details', // اختياري
              currentStep: 2,
              totalSteps: 4,
            ),
            AllTextFieldAddBranchTwo(),
          ],
        ),
      ),
    );
  }
}
