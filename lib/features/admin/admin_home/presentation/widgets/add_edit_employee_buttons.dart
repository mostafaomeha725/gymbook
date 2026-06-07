import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:gymbook/core/widgets/custom_button.dart';

class AddEditEmployeeButtons extends StatelessWidget {
  final bool isEdit;
  final VoidCallback onSave;

  const AddEditEmployeeButtons({
    super.key,
    required this.isEdit,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppButton(
          text: isEdit ? 'Save Changes' : 'Add Employee',
          height: 54.h,
          onPressed: onSave,
          textSize: 16.sp,
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF0EA5E9), Color(0xFF0284C7)],
          ),
        ),
        SizedBox(height: 12.h),
        AppButton(
          text: 'Cancel',
          color: Colors.white,
          textColor: Colors.grey.shade700,
          height: 54.h,
          elevation: 0,
          textSize: 16.sp,

          side: BorderSide(color: Colors.grey.shade300, width: 1),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            }
          },
        ),
      ],
    );
  }
}
