import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gymbook/core/theme/styles.dart';
import 'package:gymbook/core/widgets/app_form_field.dart';
import 'package:gymbook/core/widgets/custom_button.dart';
import 'package:gymbook/core/widgets/custom_text.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:go_router/go_router.dart';
import 'package:gymbook/features/auth/presentation/cubits/change_password_cubit/change_password_cubit.dart';
import 'package:gymbook/features/auth/presentation/cubits/change_password_cubit/change_password_state.dart';
import 'package:gymbook/features/auth/presentation/widgets/password_condition_widget.dart';

class ChangePasswordForm extends StatefulWidget {
  const ChangePasswordForm({super.key});

  @override
  State<ChangePasswordForm> createState() => _ChangePasswordFormState();
}

class _ChangePasswordFormState extends State<ChangePasswordForm> {
  final TextEditingController currentPasswordController =
      TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  bool isCurrentPasswordVisible = false;
  bool isNewPasswordVisible = false;
  bool isConfirmPasswordVisible = false;

  @override
  void dispose() {
    currentPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(
          'Current Password',
          style: font14w700.copyWith(color: const Color(0xFF374151)),
        ),
        SizedBox(height: 8.h),
        AppFormField(
          controller: currentPasswordController,
          hintText: 'Enter current password',
          obsecureText: !isCurrentPasswordVisible,
          maxLines: 1,
          prefixIcon: const Icon(Icons.lock_outline, color: Color(0xFF9CA3AF)),
          suffixIcon: GestureDetector(
            onTap: () => setState(
              () => isCurrentPasswordVisible = !isCurrentPasswordVisible,
            ),
            child: Icon(
              isCurrentPasswordVisible
                  ? Icons.visibility
                  : Icons.visibility_off,
              color: const Color(0xFF9CA3AF),
            ),
          ),
        ),
        SizedBox(height: 24.h),

        AppText(
          'New Password',
          style: font14w700.copyWith(color: const Color(0xFF374151)),
        ),
        SizedBox(height: 8.h),
        AppFormField(
          controller: newPasswordController,
          hintText: 'Enter new password',
          obsecureText: !isNewPasswordVisible,
          maxLines: 1,
          prefixIcon: const Icon(Icons.lock_outline, color: Color(0xFF9CA3AF)),
          suffixIcon: GestureDetector(
            onTap: () =>
                setState(() => isNewPasswordVisible = !isNewPasswordVisible),
            child: Icon(
              isNewPasswordVisible ? Icons.visibility : Icons.visibility_off,
              color: const Color(0xFF9CA3AF),
            ),
          ),
          onChanged: (value) => setState(() {}),
        ),
        SizedBox(height: 24.h),

        AppText(
          'Confirm New Password',
          style: font14w700.copyWith(color: const Color(0xFF374151)),
        ),
        SizedBox(height: 8.h),
        AppFormField(
          controller: confirmPasswordController,
          hintText: 'Enter confirm new password',
          obsecureText: !isConfirmPasswordVisible,
          maxLines: 1,
          prefixIcon: const Icon(Icons.lock_outline, color: Color(0xFF9CA3AF)),
          suffixIcon: GestureDetector(
            onTap: () => setState(
              () => isConfirmPasswordVisible = !isConfirmPasswordVisible,
            ),
            child: Icon(
              isConfirmPasswordVisible
                  ? Icons.visibility
                  : Icons.visibility_off,
              color: const Color(0xFF9CA3AF),
            ),
          ),
        ),
        SizedBox(height: 24.h),

        // Password Conditions Widget
        AnimatedBuilder(
          animation: Listenable.merge([
            newPasswordController,
            confirmPasswordController,
          ]),
          builder: (context, child) {
            return Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: const Color(0xFFF0F9FF),
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: const Color(0xFFE0F2FE)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.verified_user,
                        color: const Color(0xFF0EA5E9),
                        size: 18.sp,
                      ),
                      SizedBox(width: 8.w),
                      AppText(
                        'Password must contain:',
                        style: font14w700.copyWith(
                          color: const Color(0xFF0EA5E9),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12.h),
                  PasswordConditionsWidget(
                    password: newPasswordController.text,
                    confirmPassword: confirmPasswordController.text,
                  ),
                ],
              ),
            );
          },
        ),
        SizedBox(height: 32.h),

        // Update Password Button
        BlocConsumer<ChangePasswordCubit, ChangePasswordState>(
          listener: (context, state) {
            if (state is ChangePasswordLoading) {
              EasyLoading.show(status: 'Updating...');
            } else if (state is ChangePasswordSuccess) {
              EasyLoading.showSuccess('Password updated successfully');
              GoRouter.of(context).pop();
            } else if (state is ChangePasswordFailure) {
              EasyLoading.showError(state.message);
            }
          },
          builder: (context, state) {
            return AppButton(
              text: 'Update Password',
              gradient: const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF0EA5E9), Color(0xFF0284C7)],
              ),
              onPressed: () {
                // FocusScope.of(context).unfocus(); // Optional
                final currentPassword = currentPasswordController.text;
                final newPassword = newPasswordController.text;
                final confirmNewPassword = confirmPasswordController.text;

                if (currentPassword.isEmpty ||
                    newPassword.isEmpty ||
                    confirmNewPassword.isEmpty) {
                  EasyLoading.showToast('Please fill all fields');
                  return;
                }

                if (newPassword != confirmNewPassword) {
                  EasyLoading.showError('Passwords do not match');
                  return;
                }

                context.read<ChangePasswordCubit>().changePassword(
                  currentPassword: currentPassword,
                  newPassword: newPassword,
                  confirmNewPassword: confirmNewPassword,
                );
              },
            );
          },
        ),
        SizedBox(height: 32.h),
      ],
    );
  }
}
