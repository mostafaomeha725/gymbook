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
import 'package:gymbook/features/admin_home/data/models/branch_list_model.dart';
import 'package:gymbook/features/admin_home/domain/entities/branch_setup_details_entity.dart';
import 'package:gymbook/features/admin_home/presentation/cubits/branch_location_cubit/branch_location_cubit.dart';
import 'package:gymbook/features/admin_home/presentation/cubits/governorates_cubit/governorates_cubit.dart';
import 'package:gymbook/features/admin_home/presentation/cubits/governorates_cubit/governorates_state.dart';
import 'package:gymbook/features/auth/presentation/widgets/location_on_map_card.dart';

part 'all_text_field_add_branch_two_actions.dart';

class AllTextFieldAddBranchTwo extends StatefulWidget {
  final int branchId;
  final BranchScreenArgs? args;
  final BranchSetupDetailsEntity? setupDetails;

  const AllTextFieldAddBranchTwo({
    super.key,
    this.branchId = 0,
    this.args,
    this.setupDetails,
  });

  @override
  State<AllTextFieldAddBranchTwo> createState() =>
      _AllTextFieldAddBranchTwoState();
}

class _AllTextFieldAddBranchTwoState extends State<AllTextFieldAddBranchTwo> {
  final TextEditingController addresscontroller = TextEditingController();
  String? selectedGovernorate;
  int? selectedGovernorateId;
  double? selectedLatitude;
  double? selectedLongitude;

  @override
  void initState() {
    super.initState();
    _applyFromBranchArgs();

    final setupDetails = widget.setupDetails;
    if (setupDetails != null) {
      _applyFromSetupDetails(setupDetails);
    }
  }

  @override
  void didUpdateWidget(covariant AllTextFieldAddBranchTwo oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.setupDetails != widget.setupDetails &&
        widget.setupDetails != null) {
      _applyFromSetupDetails(widget.setupDetails!);
      setState(() {});
    }
  }

  @override
  void dispose() {
    addresscontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final governoratesState = context.watch<GovernoratesCubit>().state;
    return BlocListener<BranchLocationCubit, BranchLocationState>(
      listener: (context, state) {
        if (state is BranchLocationSuccess) {
          CustomSnackBar.showSuccess(
            context,
            message: 'Location saved successfully',
          );
          if (widget.args?.isEditMode == true) {
            GoRouter.of(context).pop(true);
          } else {
            GoRouter.of(context).push(
              '${Routes.addBranchThreeScreen}?branchId=${widget.branchId}',
            );
          }
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
              isLoading: governoratesState is GovernoratesLoading,
              governorates: _governorateItemsFromState(governoratesState),
              onMenuOpen: () {
                context.read<GovernoratesCubit>().getAllGovernorates();
              },
              onChanged: (value) {
                setState(() {
                  selectedGovernorate = value;
                });
              },
              onChangedId: (value) {
                selectedGovernorateId = value;
              },
            ),
            SizedBox(height: 16.h),
            LocationOnMapCard(
              borderColor: const Color(0xff0EA5E9),
              initialLatitude: selectedLatitude,
              initialLongitude: selectedLongitude,
              initialAddress: addresscontroller.text.trim(),
              onAddressSelected: (address) {
                addresscontroller.text = address;
              },
              onLocationSelected: (latitude, longitude) {
                selectedLatitude = latitude;
                selectedLongitude = longitude;
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
              text: widget.args?.isEditMode == true
                  ? 'Save Changes'
                  : 'Next: Working Hours',
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
