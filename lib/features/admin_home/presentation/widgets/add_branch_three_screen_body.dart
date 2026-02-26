import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:gymbook/core/routes/route_paths.dart';
import 'package:gymbook/core/widgets/custom_button.dart';
import 'package:gymbook/core/widgets/custom_snack_bar.dart';
import 'package:gymbook/features/admin_home/presentation/cubits/branch_working_hours_cubit/branch_working_hours_cubit.dart';
import 'package:gymbook/features/admin_home/presentation/widgets/branch_working_hours.dart';
import 'package:gymbook/features/admin_home/presentation/widgets/working_hours_tip.dart';
import 'package:gymbook/features/auth/presentation/widgets/appbar_auth_card.dart';

class AddBranchThreeScreenBody extends StatefulWidget {
  final int branchId;
  final bool isEditMode;

  const AddBranchThreeScreenBody({
    super.key,
    this.branchId = 0,
    this.isEditMode = false,
  });

  @override
  State<AddBranchThreeScreenBody> createState() =>
      _AddBranchThreeScreenBodyState();
}

class _AddBranchThreeScreenBodyState extends State<AddBranchThreeScreenBody> {
  Map<String, dynamic>? branchHours;
  bool _isLoading = false;

  Future<void> _submitWorkingHours() async {
    setState(() => _isLoading = true);

    final success = await context
        .read<BranchWorkingHoursCubit>()
        .submitBranchWorkingHours(
          branchId: widget.branchId,
          branchHours: branchHours,
        );

    setState(() => _isLoading = false);

    if (!mounted) return;

    if (success) {
      CustomSnackBar.showSuccess(
        context,
        message: 'Working hours saved successfully',
      );
      if (widget.isEditMode) {
        GoRouter.of(context).pop(true);
      } else {
        GoRouter.of(
          context,
        ).push('${Routes.addBranchFourScreen}?branchId=${widget.branchId}');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          children: [
            const AppbarAuthCard(
              title: 'Login',
              subtitle: 'Step 3 of 4: Working Hours',
              currentStep: 3,
              totalSteps: 4,
            ),
            SizedBox(height: 24.h),

            BranchWorkingHours(
              onHoursChanged: (hours) {
                setState(() {
                  branchHours = hours;
                });
              },
            ),
            SizedBox(height: 16.h),
            const WorkingHoursTip(),

            SizedBox(height: 16.h),
            AppButton(
              text: widget.isEditMode ? 'Save Changes' : 'Next: Add Photos',
              onPressed: _isLoading ? null : _submitWorkingHours,
              textSize: 16.sp,
              contentPadding: EdgeInsets.symmetric(horizontal: 8.w),
              gradient: const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF0EA5E9), Color(0xFF0284C7)],
              ),
            ),

            SizedBox(height: 32.h),
          ],
        ),
      ),
    );
  }
}
