import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:gymbook/core/routes/route_paths.dart';
import 'package:gymbook/core/widgets/custom_button.dart';
import 'package:gymbook/core/widgets/custom_snack_bar.dart';
import 'package:gymbook/features/admin_home/domain/entities/branch_setup_details_entity.dart';
import 'package:gymbook/features/admin_home/presentation/cubits/branch_setup_cubit/branch_setup_cubit.dart';
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

  Map<String, dynamic>? _mapFromSetupDetails(
    BranchSetupDetailsEntity? setupDetails,
  ) {
    if (setupDetails == null || setupDetails.workingHours.isEmpty) {
      return null;
    }

    return {
      'workingHours': setupDetails.workingHours
          .map(
            (item) => <String, dynamic>{
              'day': item.day,
              'openTime': item.isClosed ? null : item.openTime,
              'closeTime': item.isClosed ? null : item.closeTime,
              'isClosed': item.isClosed,
            },
          )
          .toList(),
    };
  }

  Future<void> _submitWorkingHours() async {
    setState(() => _isLoading = true);

    final setupDetails = context.read<BranchSetupCubit>().state.details;
    final payload = branchHours ?? _mapFromSetupDetails(setupDetails);

    final success = await context
        .read<BranchWorkingHoursCubit>()
        .submitBranchWorkingHours(
          branchId: widget.branchId,
          branchHours: payload,
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
    return BlocConsumer<BranchSetupCubit, BranchSetupState>(
      listenWhen: (previous, current) =>
          previous.errorMessage != current.errorMessage,
      listener: (context, state) {
        if (state.errorMessage != null && state.errorMessage!.isNotEmpty) {
          CustomSnackBar.showError(context, message: state.errorMessage!);
        }
      },
      builder: (context, setupState) {
        final shouldShowLoading =
            widget.isEditMode && setupState.isLoading && !setupState.hasData;

        return SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Column(
              children: [
                AppbarAuthCard(
                  title: widget.isEditMode ? 'Edit Branch' : 'Add Branch',
                  subtitle: 'Step 3 of 4: Working Hours',
                  currentStep: 3,
                  totalSteps: 4,
                ),
                SizedBox(height: 24.h),
                if (shouldShowLoading)
                  Padding(
                    padding: EdgeInsets.only(top: 64.h),
                    child: const Center(child: CircularProgressIndicator()),
                  )
                else
                  BranchWorkingHours(
                    initialWorkingHours: setupState.details?.workingHours,
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
      },
    );
  }
}
