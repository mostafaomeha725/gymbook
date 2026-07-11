import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gymbook/core/widgets/app_form_field.dart';
import 'package:gymbook/features/admin/admin_home/presentation/widgets/labeled_form_field.dart';

class EmployeeNameFields extends StatelessWidget {
  final TextEditingController firstNameController;
  final TextEditingController lastNameController;

  const EmployeeNameFields({
    super.key,
    required this.firstNameController,
    required this.lastNameController,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: LabeledFormField(
            label: 'First Name',
            input: AppFormField(
              controller: firstNameController,
              hintText: 'First Name',
              prefixIcon: const Icon(Icons.person_outline, size: 20),
              validator: (val) {
                return null;
              },
            ),
          ),
        ),
        SizedBox(width: 16.w),
        Expanded(
          child: LabeledFormField(
            label: 'Last Name',
            input: AppFormField(
              controller: lastNameController,
              hintText: 'Last Name',
              prefixIcon: const Icon(Icons.person_outline, size: 20),
              validator: (val) {
                return null;
              },
            ),
          ),
        ),
      ],
    );
  }
}
