import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:gymbook/core/di/services_locator.dart';
import 'package:gymbook/core/routes/route_paths.dart';
import 'package:gymbook/core/utils/easy_loading.dart';
import 'package:gymbook/features/admin_home/data/models/branch_list_model.dart';
import 'package:gymbook/features/admin_home/presentation/cubits/branch_setup_cubit/branch_setup_cubit.dart';
import 'package:gymbook/features/admin_home/presentation/cubits/create_branch_cubit/create_branch_cubit.dart';
import 'package:gymbook/features/admin_home/presentation/widgets/all_text_field_add_branch_one.dart';
import 'package:gymbook/features/auth/presentation/widgets/appbar_auth_card.dart';

class AddBranchOneScreenBody extends StatelessWidget {
  final BranchScreenArgs? args;

  const AddBranchOneScreenBody({super.key, this.args});

  @override
  Widget build(BuildContext context) {
    final isEditMode = args?.isEditMode == true;

    return BlocProvider(
      create: (_) => sl<CreateBranchCubit>(),
      child: MultiBlocListener(
        listeners: [
          BlocListener<CreateBranchCubit, CreateBranchState>(
            listener: (context, state) {
              if (state is CreateBranchSuccess) {
                hideLoading();
                if (isEditMode) {
                  showSuccess('Business details updated successfully');
                  GoRouter.of(context).pop(true);
                } else {
                  showSuccess('Branch created successfully!');
                  GoRouter.of(context).go(
                    '${Routes.addBranchTwoScreen}?branchId=${state.branchResponse.id}',
                  );
                }
              }
            },
          ),
          BlocListener<BranchSetupCubit, BranchSetupState>(
            listenWhen: (previous, current) =>
                previous.errorMessage != current.errorMessage,
            listener: (context, state) {
              if (state.errorMessage != null &&
                  state.errorMessage!.isNotEmpty) {
                showError(state.errorMessage!);
              }
            },
          ),
        ],
        child: BlocBuilder<BranchSetupCubit, BranchSetupState>(
          builder: (context, setupState) {
            final shouldWaitForLoadedState = isEditMode && !setupState.hasData;

            final shouldShowLoading =
                shouldWaitForLoadedState &&
                (setupState.isLoading || setupState.errorMessage == null);

            return SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Column(
                  children: [
                    AppbarAuthCard(
                      title: isEditMode ? 'Edit Branch' : 'Add Branch',
                      subtitle: 'Step 1 of 4: Business Details',
                      currentStep: 1,
                      totalSteps: 4,
                    ),
                    if (shouldShowLoading)
                      Padding(
                        padding: EdgeInsets.only(top: 64.h),
                        child: const Center(child: CircularProgressIndicator()),
                      )
                    else if (shouldWaitForLoadedState)
                      Padding(
                        padding: EdgeInsets.only(top: 48.h),
                        child: Column(
                          children: [
                            const Icon(
                              Icons.error_outline,
                              color: Color(0xffEF4444),
                              size: 30,
                            ),
                            SizedBox(height: 10.h),
                            Text(
                              setupState.errorMessage ??
                                  'Unable to load branch details.',
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 12.h),
                            OutlinedButton(
                              onPressed: () {
                                final branchId = args?.branchId ?? 0;
                                if (branchId > 0) {
                                  context
                                      .read<BranchSetupCubit>()
                                      .fetchBranchDetails(branchId);
                                }
                              },
                              child: const Text('Retry'),
                            ),
                          ],
                        ),
                      )
                    else
                      AllTextFieldAddBranchOne(
                        args: args,
                        setupDetails: setupState.details,
                      ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
