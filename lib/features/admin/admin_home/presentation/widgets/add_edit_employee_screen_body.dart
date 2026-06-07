import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gymbook/core/widgets/appbar_subscription_widget.dart';
import 'package:gymbook/features/admin/admin_home/presentation/models/add_edit_employee_screen_args.dart';
import 'package:gymbook/features/admin/admin_home/presentation/widgets/add_edit_employee_form.dart';

class AddEditEmployeeScreenBody extends StatelessWidget {
  final AddEditEmployeeScreenArgs args;

  const AddEditEmployeeScreenBody({super.key, required this.args});

  @override
  Widget build(BuildContext context) {
    final isEdit = args.isEditMode;

    return SingleChildScrollView(
      child: Column(
        children: [
          AppbarSubscriptionWidget(
            text: isEdit ? 'Update Employee' : 'Add Employee',
            subtitle: isEdit
                ? 'Edit employee details'
                : 'Fill in the details below',
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 22.w, vertical: 24.h),
            child: AddEditEmployeeForm(args: args),
          ),
        ],
      ),
    );
  }
}
