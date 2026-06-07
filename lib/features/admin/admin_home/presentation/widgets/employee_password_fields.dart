import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gymbook/core/widgets/app_form_field.dart';
import 'package:gymbook/features/admin/admin_home/presentation/widgets/labeled_form_field.dart';

class EmployeePasswordFields extends StatefulWidget {
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final bool isEdit;

  const EmployeePasswordFields({
    super.key,
    required this.passwordController,
    required this.confirmPasswordController,
    required this.isEdit,
  });

  @override
  State<EmployeePasswordFields> createState() => _EmployeePasswordFieldsState();
}

class _EmployeePasswordFieldsState extends State<EmployeePasswordFields> {
  bool _isPasswordObscure = true;
  bool _isConfirmPasswordObscure = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LabeledFormField(
          label: 'Password',
          input: AppFormField(
            controller: widget.passwordController,
            hintText: 'Min. 6 characters',
            obsecureText: _isPasswordObscure,
            maxLines: 1,
            prefixIcon: const Icon(Icons.lock_outline, size: 20),
            validator: (val) {
              if (!widget.isEdit && (val == null || val.isEmpty)) {
                return 'Required';
              }
              return null;
            },
            suffixIcon: GestureDetector(
              onTap: () => setState(() {
                _isPasswordObscure = !_isPasswordObscure;
              }),
              child: Icon(
                _isPasswordObscure
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                size: 20,
              ),
            ),
          ),
        ),
        SizedBox(height: 16.h),
        LabeledFormField(
          label: 'Confirm Password',
          input: AppFormField(
            controller: widget.confirmPasswordController,
            hintText: 'Re-enter password',
            maxLines: 1,
            obsecureText: _isConfirmPasswordObscure,
            prefixIcon: const Icon(Icons.lock_outline, size: 20),
            validator: (val) {
              if (!widget.isEdit && (val == null || val.isEmpty)) {
                return 'Required';
              }
              return null;
            },
            suffixIcon: GestureDetector(
              onTap: () => setState(() {
                _isConfirmPasswordObscure = !_isConfirmPasswordObscure;
              }),
              child: Icon(
                _isConfirmPasswordObscure
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                size: 20,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
