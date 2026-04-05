import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:gymbook/core/routes/route_paths.dart';
import 'package:gymbook/core/theme/styles.dart';
import 'package:gymbook/core/utils/validators.dart';
import 'package:gymbook/core/widgets/app_form_field.dart';
import 'package:gymbook/core/widgets/custom_button.dart';
import 'package:gymbook/core/widgets/custom_text.dart';
import 'package:gymbook/features/auth/presentation/cubits/reset_password_cubit/reset_password_cubit.dart';
import 'package:gymbook/features/auth/presentation/screens/reset_password_screen.dart';
import 'package:gymbook/features/auth/presentation/widgets/appbar_auth_card.dart';
import 'package:gymbook/features/auth/presentation/widgets/auth_icon_badge.dart';

class ResetPasswordScreenBody extends StatefulWidget {
  const ResetPasswordScreenBody({super.key, required this.args});

  final ResetPasswordScreenArgs args;

  @override
  State<ResetPasswordScreenBody> createState() =>
      _ResetPasswordScreenBodyState();
}

class _ResetPasswordScreenBodyState extends State<ResetPasswordScreenBody> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _isNewPasswordObscure = true;
  bool _isConfirmPasswordObscure = true;
  bool _submitted = false;

  @override
  void dispose() {
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _onSubmit() {
    setState(() => _submitted = true);

    if (!_formKey.currentState!.validate()) return;

    context.read<ResetPasswordCubit>().resetPassword(
      email: widget.args.email,
      code: widget.args.code,
      newPassword: _newPasswordController.text.trim(),
      confirmNewPassword: _confirmPasswordController.text.trim(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ResetPasswordCubit, ResetPasswordState>(
      listener: (context, state) {
        if (state is ResetPasswordSuccess) {
          GoRouter.of(context).go(Routes.loginScreen);
        }
      },
      child: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: const AppbarAuthCard(
                title: 'Reset Password',
                subtitle: 'Create a new strong password for your account',
                currentStep: 3,
                totalSteps: 3,
              ),
            ),

            SizedBox(height: 28.h),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Column(
                children: [
                  const AuthIconBadge(
                    icon: Icons.lock_outline_rounded,
                    padding: 20,
                    iconSize: 40,
                  ),

                  SizedBox(height: 18.h),

                  AppText(
                    'New Password',
                    style: font32w700.copyWith(color: const Color(0xFF2C3E50)),
                    alignment: AlignmentDirectional.center,
                  ),

                  SizedBox(height: 8.h),

                  AppText(
                    'Enter and confirm your new password below',
                    style: font16w400.copyWith(color: const Color(0xFF8A8F9B)),
                    alignment: AlignmentDirectional.center,
                  ),

                  SizedBox(height: 28.h),
                ],
              ),
            ),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 28.w),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(
                      'New Password',
                      style: font18w500.copyWith(
                        color: const Color(0xFF2C3E50),
                      ),
                    ),
                    SizedBox(height: 8.h),
                    AppFormField(
                      controller: _newPasswordController,
                      hintText: 'Enter new password',
                      maxLines: 1,
                      obsecureText: _isNewPasswordObscure,
                      radius: 14.r,
                      borderColor: const Color(0xFFD5DAE1),
                      fillColor: Colors.white,
                      prefixIcon: Icon(
                        Icons.lock_outline,
                        color: const Color(0xFF9CA3AF),
                        size: 20.sp,
                      ),
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            _isNewPasswordObscure = !_isNewPasswordObscure;
                          });
                        },
                        icon: Icon(
                          _isNewPasswordObscure
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                          color: const Color(0xFF9CA3AF),
                          size: 20.sp,
                        ),
                      ),
                      onChanged: (_) {
                        if (_submitted) {
                          _formKey.currentState?.validate();
                        }
                      },
                      validator: (value) {
                        if (!_submitted) return null;
                        return Validators.password(
                          value,
                          minLength: 4,
                          emptyMessage: 'Please enter new password',
                          minLengthMessage:
                              'Password must be at least 4 characters',
                        );
                      },
                    ),

                    SizedBox(height: 18.h),

                    AppText(
                      'Confirm Password',
                      style: font18w500.copyWith(
                        color: const Color(0xFF2C3E50),
                      ),
                    ),
                    SizedBox(height: 8.h),
                    AppFormField(
                      controller: _confirmPasswordController,
                      hintText: 'Confirm new password',
                      maxLines: 1,
                      obsecureText: _isConfirmPasswordObscure,
                      radius: 14.r,
                      borderColor: const Color(0xFFD5DAE1),
                      fillColor: Colors.white,
                      prefixIcon: Icon(
                        Icons.lock_outline,
                        color: const Color(0xFF9CA3AF),
                        size: 20.sp,
                      ),
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            _isConfirmPasswordObscure =
                                !_isConfirmPasswordObscure;
                          });
                        },
                        icon: Icon(
                          _isConfirmPasswordObscure
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                          color: const Color(0xFF9CA3AF),
                          size: 20.sp,
                        ),
                      ),
                      onChanged: (_) {
                        if (_submitted) {
                          _formKey.currentState?.validate();
                        }
                      },
                      validator: (value) {
                        if (!_submitted) return null;
                        return Validators.confirmPassword(
                          value,
                          originalPassword: _newPasswordController.text,
                          emptyMessage: 'Please confirm new password',
                        );
                      },
                    ),

                    SizedBox(height: 26.h),

                    AppButton(
                      text: 'Reset Password',
                      onPressed: _onSubmit,
                      textSize: 16.sp,
                      radius: 14.r,
                      gradient: const LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Color(0xFF0EA5E9), Color(0xFF0284C7)],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 40.h),
          ],
        ),
      ),
    );
  }
}
