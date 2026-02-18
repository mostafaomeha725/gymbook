import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:gymbook/core/routes/route_paths.dart';
import 'package:gymbook/core/theme/styles.dart';
import 'package:gymbook/core/widgets/app_form_field.dart';
import 'package:gymbook/core/widgets/custom_button.dart';
import 'package:gymbook/core/widgets/custom_text.dart';
import 'package:gymbook/core/widgets/governorate_dropdown.dart';
import 'package:gymbook/features/auth/presentation/widgets/location_on_map_card.dart';

class AllTextFieldAddBranchTwo extends StatefulWidget {
  const AllTextFieldAddBranchTwo({super.key});

  @override
  State<AllTextFieldAddBranchTwo> createState() =>
      _AllTextFieldAddBranchTwoState();
}

class _AllTextFieldAddBranchTwoState extends State<AllTextFieldAddBranchTwo> {
  final TextEditingController addresscontroller = TextEditingController();

  String? selectedGovernorate;

  @override
  Widget build(BuildContext context) {
    return Padding(
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
          const LocationOnMapCard(borderColor: Color(0xff0EA5E9)),
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
            onPressed: () {
              GoRouter.of(context).push(Routes.otpScreen);
            },
            textSize: 16.sp,
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF0EA5E9), Color(0xFF0284C7)],
            ),
          ),
        ],
      ),
    );
  }
}
