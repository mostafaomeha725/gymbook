import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:gymbook/core/widgets/custom_button.dart';
import 'package:gymbook/features/admin/admin_home/data/models/package_screen_args.dart';
import 'package:gymbook/features/admin/admin_home/presentation/cubits/create_package_cubit/create_package_cubit.dart';
import 'package:gymbook/features/admin/admin_home/presentation/widgets/add_package_widgets/package_form_fields.dart';
import 'package:gymbook/features/admin/admin_home/presentation/widgets/add_package_widgets/package_status_switch.dart';
import 'package:gymbook/features/admin/admin_home/presentation/widgets/mixins/add_package_logic_mixin.dart';

class AddNewPackageTextFieldBody extends StatefulWidget {
  final PackageScreenArgs args;

  const AddNewPackageTextFieldBody({super.key, required this.args});

  @override
  State<AddNewPackageTextFieldBody> createState() =>
      _AddNewPackageTextFieldBodyState();
}

class _AddNewPackageTextFieldBodyState
    extends State<AddNewPackageTextFieldBody> with AddPackageLogicMixin {
  
  @override
  void initState() {
    super.initState();
    initControllers();
  }

  @override
  void dispose() {
    disposeControllers();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CreatePackageCubit, CreatePackageState>(
      listener: (context, state) {
        if (state is CreatePackageSuccess) {
          GoRouter.of(context).pop(true);
        }
      },
      child: Container(
        padding: EdgeInsets.all(18.w),
        margin: EdgeInsets.symmetric(horizontal: 22.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 16.r,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PackageFormFields(
              nameController: nameController,
              priceController: priceController,
              durationController: durationController,
              freezesController: freezesController,
              freezeDurationController: freezeDurationController,
            ),
            
            SizedBox(height: 16.h),
            
            PackageStatusSwitch(
              isActive: isActive,
              onChanged: (v) => setState(() => isActive = v),
            ),
            
            SizedBox(height: 24.h),
            
            AppButton(
              text: isEditMode ? 'Update Package' : 'Add Package',
              textSize: 16.sp,
              gradient: const LinearGradient(
                colors: [Color(0xFF0EA5E9), Color(0xFF0284C7)],
              ),
              onPressed: () => submitPackage(context),
            ),
          ],
        ),
      ),
    );
  }
}

