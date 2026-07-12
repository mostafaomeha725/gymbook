import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gymbook/core/widgets/app_form_field.dart';
import 'package:gymbook/features/admin/admin_home/presentation/widgets/add_package_widgets/form_field_label.dart';

class PackageFormFields extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController priceController;
  final TextEditingController durationController;
  final TextEditingController freezesController;
  final TextEditingController freezeDurationController;

  const PackageFormFields({
    super.key,
    required this.nameController,
    required this.priceController,
    required this.durationController,
    required this.freezesController,
    required this.freezeDurationController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const FormFieldLabel(text: 'Package Name'),
        AppFormField(
          controller: nameController,
          hintText: 'e.g., Premium Monthly',
          radius: 16.r,
        ),
        SizedBox(height: 16.h),

        const FormFieldLabel(text: 'Price (EGP)'),
        AppFormField(
          controller: priceController,
          hintText: '500',
          keyboardType: TextInputType.number,
          radius: 16.r,
        ),
        SizedBox(height: 16.h),

        const FormFieldLabel(text: 'Duration (Months)'),
        AppFormField(
          controller: durationController,
          hintText: '1',
          keyboardType: TextInputType.number,
          radius: 16.r,
        ),
        SizedBox(height: 16.h),

        const FormFieldLabel(text: 'Number of Freezes Allowed'),
        AppFormField(
          controller: freezesController,
          hintText: '0',
          keyboardType: TextInputType.number,
          radius: 16.r,
        ),
        SizedBox(height: 16.h),

        const FormFieldLabel(text: 'Freeze Duration (Days)'),
        AppFormField(
          controller: freezeDurationController,
          hintText: '0',
          keyboardType: TextInputType.number,
          radius: 16.r,
        ),
      ],
    );
  }
}
