import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:gymbook/core/di/services_locator.dart';
import 'package:gymbook/core/routes/route_paths.dart';
import 'package:gymbook/core/utils/easy_loading.dart';
import 'package:gymbook/features/admin_home/presentation/cubits/create_branch_cubit/create_branch_cubit.dart';
import 'package:gymbook/features/admin_home/presentation/widgets/all_text_field_add_branch_one.dart';
import 'package:gymbook/features/auth/presentation/widgets/appbar_auth_card.dart';

class AddBranchOneScreenBody extends StatelessWidget {
  const AddBranchOneScreenBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<CreateBranchCubit>(),
      child: BlocListener<CreateBranchCubit, CreateBranchState>(
        listener: (context, state) {
          if (state is CreateBranchSuccess) {
            hideLoading();
            showSuccess('Branch created successfully!');
            GoRouter.of(context).go(
              '${Routes.addBranchTwoScreen}?branchId=${state.branchResponse.id}',
            );
          }
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: const Column(
              children: [
                AppbarAuthCard(
                  title: 'Add Branch',
                  subtitle: 'Step 1 of 4: Business Details',
                  currentStep: 1,
                  totalSteps: 4,
                ),
                AllTextFieldAddBranchOne(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
