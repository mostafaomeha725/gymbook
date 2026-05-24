import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:gymbook/core/theme/styles.dart';
import 'package:gymbook/core/widgets/app_form_field.dart';
import 'package:gymbook/core/widgets/custom_button.dart';
import 'package:gymbook/core/widgets/custom_text.dart';
import 'package:gymbook/features/admin/admin_home/data/models/package_screen_args.dart';
import 'package:gymbook/features/admin/admin_home/presentation/cubits/create_package_cubit/create_package_cubit.dart';

class AddNewPackageTextFieldBody extends StatefulWidget {
  final PackageScreenArgs args;

  const AddNewPackageTextFieldBody({super.key, required this.args});

  @override
  State<AddNewPackageTextFieldBody> createState() =>
      _AddNewPackageTextFieldBodyState();
}

class _AddNewPackageTextFieldBodyState
    extends State<AddNewPackageTextFieldBody> {
  late final TextEditingController nameController;
  late final TextEditingController priceController;
  late final TextEditingController durationController;
  late final TextEditingController freezesController;
  late bool _isActive;

  bool get _isEditMode => widget.args.isEditMode;

  @override
  void initState() {
    super.initState();
    final pkg = widget.args.packageItem;
    nameController = TextEditingController(text: pkg?.name ?? '');
    priceController = TextEditingController(
      text: pkg != null ? _formatPrice(pkg.price) : '',
    );
    durationController = TextEditingController(
      text: pkg != null ? pkg.durationInMonths.toString() : '',
    );
    freezesController = TextEditingController(
      text: pkg != null ? pkg.numberOfFreezes.toString() : '',
    );
    _isActive = pkg?.isActive ?? true;
  }

  String _formatPrice(double value) {
    final hasFraction = value % 1 != 0;
    return hasFraction ? value.toStringAsFixed(2) : value.toStringAsFixed(0);
  }

  @override
  void dispose() {
    nameController.dispose();
    priceController.dispose();
    durationController.dispose();
    freezesController.dispose();
    super.dispose();
  }

  Widget _label(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 6.h),
      child: AppText(
        text,
        style: font14w700.copyWith(color: const Color(0xff364153)),
      ),
    );
  }

  void _submit(BuildContext context) {
    if (_isEditMode) {
      context.read<CreatePackageCubit>().updatePackage(
        branchId: widget.args.branchId,
        packageId: widget.args.packageItem!.id,
        name: nameController.text,
        priceText: priceController.text,
        durationText: durationController.text,
        freezesText: freezesController.text,
        isActive: _isActive,
      );
    } else {
      context.read<CreatePackageCubit>().submitPackage(
        branchId: widget.args.branchId,
        name: nameController.text,
        priceText: priceController.text,
        durationText: durationController.text,
        freezesText: freezesController.text,
        isActive: _isActive,
      );
    }
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
            _label('Package Name'),
            AppFormField(
              controller: nameController,
              hintText: 'e.g., Premium Monthly',
              radius: 16.r,
            ),

            SizedBox(height: 16.h),

            _label('Price (EGP)'),
            AppFormField(
              controller: priceController,
              hintText: '500',
              keyboardType: TextInputType.number,
              radius: 16.r,
            ),

            SizedBox(height: 16.h),

            _label('Duration (Months)'),
            AppFormField(
              controller: durationController,
              hintText: '1',
              keyboardType: TextInputType.number,
              radius: 16.r,
            ),

            SizedBox(height: 16.h),

            _label('Number of Freezes Allowed'),
            AppFormField(
              controller: freezesController,
              hintText: '0',
              keyboardType: TextInputType.number,
              radius: 16.r,
            ),

            SizedBox(height: 16.h),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _label('Active'),
                Switch.adaptive(
                  value: _isActive,
                  activeColor: const Color(0xFF0EA5E9),
                  onChanged: (v) => setState(() => _isActive = v),
                ),
              ],
            ),

            SizedBox(height: 24.h),

            AppButton(
              text: _isEditMode ? 'Update Package' : 'Add Package',
              textSize: 16.sp,
              gradient: const LinearGradient(
                colors: [Color(0xFF0EA5E9), Color(0xFF0284C7)],
              ),
              onPressed: () => _submit(context),
            ),
          ],
        ),
      ),
    );
  }
}
