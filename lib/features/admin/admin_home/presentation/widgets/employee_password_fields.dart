import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gymbook/core/widgets/app_form_field.dart';
import 'package:gymbook/features/admin/admin_home/presentation/widgets/labeled_form_field.dart';
import 'package:gymbook/features/auth/presentation/widgets/password_condition_widget.dart';

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
            hintText: 'Enter your password',
            obsecureText: _isPasswordObscure,
            maxLines: 1,
            prefixIcon: const Icon(Icons.lock_outline, size: 20),
            validator: (val) {
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
        SizedBox(height: 8.h),
        AnimatedBuilder(
          animation: Listenable.merge([
            widget.passwordController,
            widget.confirmPasswordController,
          ]),
          builder: (context, child) {
            return PasswordConditionsWidget(
              password: widget.passwordController.text,
              confirmPassword: widget.confirmPasswordController.text,
            );
          },
        ),
      ],
    );
  }
}
