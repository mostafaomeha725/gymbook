import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:gymbook/core/routes/route_paths.dart';
import 'package:gymbook/core/theme/styles.dart';
import 'package:gymbook/core/widgets/app_form_field.dart';
import 'package:gymbook/core/widgets/custom_button.dart';
import 'package:gymbook/core/widgets/custom_snack_bar.dart';
import 'package:gymbook/core/widgets/custom_text.dart';
import 'package:gymbook/core/widgets/governorate_dropdown.dart';
import 'package:gymbook/features/admin_home/presentation/cubits/branch_location_cubit/branch_location_cubit.dart';
import 'package:gymbook/features/auth/presentation/widgets/location_on_map_card.dart';

class AllTextFieldAddBranchTwo extends StatefulWidget {
  final int branchId;

  const AllTextFieldAddBranchTwo({super.key, this.branchId = 0});

  @override
  State<AllTextFieldAddBranchTwo> createState() =>
      _AllTextFieldAddBranchTwoState();
}

class _AllTextFieldAddBranchTwoState extends State<AllTextFieldAddBranchTwo> {
  final TextEditingController addresscontroller = TextEditingController();
  String? selectedGovernorate;

  @override
  void dispose() {
    addresscontroller.dispose();
    super.dispose();
  }

  void _submit() {
    context.read<BranchLocationCubit>().submitLocationDetails(
      branchId: widget.branchId,
      governorateName: selectedGovernorate,
      address: addresscontroller.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<BranchLocationCubit, BranchLocationState>(
      listener: (context, state) {
        if (state is BranchLocationSuccess) {
          CustomSnackBar.showSuccess(
            context,
            message: 'Location saved successfully',
          );
          GoRouter.of(
            context,
          ).push('${Routes.addBranchThreeScreen}?branchId=${widget.branchId}');
        }
      },
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          children: [
            SizedBox(height: 24.h),

            GovernorateDropdown(
              labelText: 'Select Governorate',
              initialValue: selectedGovernorate,
              borderColor: const Color(0xffE5E7EB),
              onChanged: (value) {
                setState(() {
                  selectedGovernorate = value;
                });
              },
            ),
            SizedBox(height: 16.h),
            LocationOnMapCard(
              borderColor: const Color(0xff0EA5E9),
              onAddressSelected: (address) {
                addresscontroller.text = address;
              },
            ),
            SizedBox(height: 24.h),

            AppText(
              'Address',
              style: font14w500.copyWith(color: const Color(0xff364153)),
            ),
            SizedBox(height: 8.h),
            AppFormField(
              controller: addresscontroller,
              hintText: 'Enter full address',
              maxLines: 4,
              prefixIcon: Padding(
                padding: EdgeInsets.only(left: 8.w, bottom: 78.h),
                child: Icon(Icons.location_on_outlined, size: 22.sp),
              ),
              radius: 22.r,
            ),
            SizedBox(height: 24.h),

            AppButton(
              text: 'Next: Working Hours',
              onPressed: _submit,
              textSize: 16.sp,
              gradient: const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF0EA5E9), Color(0xFF0284C7)],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
