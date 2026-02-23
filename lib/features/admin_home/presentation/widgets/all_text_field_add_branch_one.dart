import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gymbook/core/enums/app_enums.dart';
import 'package:gymbook/core/theme/styles.dart';
import 'package:gymbook/core/utils/easy_loading.dart';
import 'package:gymbook/core/widgets/app_form_field.dart';
import 'package:gymbook/core/widgets/custom_button.dart';
import 'package:gymbook/core/widgets/custom_text.dart';
import 'package:gymbook/features/admin_home/presentation/cubits/create_branch_cubit/create_branch_cubit.dart';
import 'package:gymbook/features/auth/presentation/widgets/gym_type_selector.dart';

class AllTextFieldAddBranchOne extends StatefulWidget {
  const AllTextFieldAddBranchOne({super.key});

  @override
  State<AllTextFieldAddBranchOne> createState() =>
      _AllTextFieldAddBranchOneState();
}

class _AllTextFieldAddBranchOneState extends State<AllTextFieldAddBranchOne> {
  final TextEditingController branchNameController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  int? selectedBranchType; // null=not selected, 0=male, 1=female, 2=mixed

  @override
  void dispose() {
    branchNameController.dispose();
    phoneNumberController.dispose();
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CreateBranchCubit, CreateBranchState>(
      listener: (context, state) {
        if (state is CreateBranchSuccess) {
          hideLoading();
        }
      },
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 24.h),
            AppText(
              'Branch Name',
              style: font14w500.copyWith(color: const Color(0xff364153)),
            ),
            SizedBox(height: 8.h),
            AppFormField(
              controller: branchNameController,
              hintText: 'Enter branch name',
              maxLines: 1,
              prefixIcon: Padding(
                padding: EdgeInsets.only(left: 8.w),
                child: Icon(Icons.store_outlined, size: 22.sp),
              ),
              radius: 22.r,
            ),
            SizedBox(height: 16.h),
            AppText(
              'Phone Number',
              style: font14w500.copyWith(color: const Color(0xff364153)),
            ),
            SizedBox(height: 8.h),
            AppFormField(
              controller: phoneNumberController,
              hintText: '+20 XXX XXX XXX',
              maxLines: 1,
              keyboardType: TextInputType.phone,
              prefixIcon: Padding(
                padding: EdgeInsets.only(left: 8.w),
                child: Icon(Icons.phone_outlined, size: 22.sp),
              ),
              radius: 22.r,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return null; // Don't show error until user tries to submit
                }

                return null;
              },
            ),
            SizedBox(height: 16.h),
            AppText(
              'Email Address',
              style: font14w500.copyWith(color: const Color(0xff364153)),
            ),
            SizedBox(height: 8.h),
            AppFormField(
              controller: emailController,
              hintText: 'branch.email@example.com',
              maxLines: 1,
              keyboardType: TextInputType.emailAddress,
              prefixIcon: Padding(
                padding: EdgeInsets.only(left: 8.w),
                child: Icon(Icons.email_outlined, size: 22.sp),
              ),
              radius: 22.r,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return null; // Don't show error until user tries to submit
                }

                return null;
              },
            ),
            SizedBox(height: 24.h),
            GymTypeSelector(
              onChanged: (value) {
                setState(() {
                  // Convert GymType enum to branch type int: menOnly=0, womenOnly=1, mixed=2
                  selectedBranchType = value == GymType.menOnly
                      ? 0
                      : value == GymType.womenOnly
                      ? 1
                      : 2;
                });
              },
            ),
            SizedBox(height: 24.h),
            AppButton(
              text: 'Create Branch',
              onPressed: () {
                final branchName = branchNameController.text.trim();
                final email = emailController.text.trim();
                final phoneNumber = phoneNumberController.text.trim();

                // Validation
                if (branchName.isEmpty) {
                  showError('Please enter branch name');
                  return;
                }

                if (email.isEmpty) {
                  showError('Please enter email');
                  return;
                }

                if (phoneNumber.isEmpty) {
                  showError('Please enter phone number');
                  return;
                }

                // Validate gym type selection
                if (selectedBranchType == null ||
                    selectedBranchType! < 0 ||
                    selectedBranchType! > 2) {
                  showError(
                    'Please select a valid gym type (Men Only, Women Only, or Mixed)',
                  );
                  return;
                }

                context.read<CreateBranchCubit>().createBranch(
                  name: branchName,
                  email: email,
                  phoneNumber: phoneNumber,
                  branchType: selectedBranchType!,
                );
              },
              textSize: 16.sp,
              gradient: const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF0EA5E9), Color(0xFF0284C7)],
              ),
            ),
            SizedBox(height: 48.h),
          ],
        ),
      ),
    );
  }
}
