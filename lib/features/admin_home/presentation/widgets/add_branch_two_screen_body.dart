import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gymbook/core/di/services_locator.dart';
import 'package:gymbook/features/admin_home/data/models/branch_list_model.dart';
import 'package:gymbook/features/admin_home/presentation/cubits/branch_setup_cubit/branch_setup_cubit.dart';
import 'package:gymbook/features/admin_home/presentation/cubits/governorates_cubit/governorates_cubit.dart';
import 'package:gymbook/features/admin_home/presentation/widgets/all_text_field_add_branch_two.dart';
import 'package:gymbook/core/widgets/custom_snack_bar.dart';
import 'package:gymbook/features/auth/presentation/widgets/appbar_auth_card.dart';

class AddBranchTwoScreenBody extends StatelessWidget {
  final int branchId;
  final BranchScreenArgs? args;

  const AddBranchTwoScreenBody({super.key, this.branchId = 0, this.args});

  @override
  Widget build(BuildContext context) {
    final isEditMode = args?.isEditMode == true;

    return BlocProvider(
      create: (_) => GovernoratesCubit(sl())..getAllGovernorates(),
      child: BlocConsumer<BranchSetupCubit, BranchSetupState>(
        listenWhen: (previous, current) =>
            previous.errorMessage != current.errorMessage,
        listener: (context, state) {
          if (state.errorMessage != null && state.errorMessage!.isNotEmpty) {
            CustomSnackBar.showError(context, message: state.errorMessage!);
          }
        },
        builder: (context, setupState) {
          final shouldShowLoading =
              isEditMode && setupState.isLoading && !setupState.hasData;

          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Column(
                children: [
                  AppbarAuthCard(
                    title: isEditMode ? 'Edit Branch' : 'Add Branch',
                    subtitle: 'Step 2 of 4: Location Details',
                    currentStep: 2,
                    totalSteps: 4,
                  ),
                  if (shouldShowLoading)
                    Padding(
                      padding: EdgeInsets.only(top: 64.h),
                      child: const Center(child: CircularProgressIndicator()),
                    )
                  else
                    AllTextFieldAddBranchTwo(
                      branchId: branchId,
                      args: args,
                      setupDetails: setupState.details,
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
