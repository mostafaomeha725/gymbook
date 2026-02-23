import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:gymbook/core/constants/app_assets.dart';
import 'package:gymbook/core/routes/route_paths.dart';
import 'package:gymbook/core/theme/styles.dart';
import 'package:gymbook/core/utils/easy_loading.dart';
import 'package:gymbook/core/widgets/app_form_field.dart';
import 'package:gymbook/core/widgets/bouncing_social_button.dart';
import 'package:gymbook/core/widgets/custom_button.dart';
import 'package:gymbook/core/widgets/custom_text.dart';
import 'package:gymbook/features/auth/presentation/cubits/login_cubit/login_cubit.dart';
import 'package:gymbook/features/auth/presentation/widgets/divider_widget.dart';

class LoginWidget extends StatefulWidget {
  const LoginWidget({super.key});

  @override
  State<LoginWidget> createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool obscurePassword = true;
  bool _formSubmitted = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state is LoginSuccess) {
          hideLoading();
          GoRouter.of(context).pushReplacement(
            Routes.mainNavigationScreen,
            extra: state.loginResponse.user.isAdmin,
          );
        }
      },
      child: Container(
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              // ignore: deprecated_member_use
              color: Colors.black.withOpacity(0.12),
              blurRadius: 35.r,
              spreadRadius: 5.r,
              offset: const Offset(0, 15),
            ),
          ],
        ),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 12.h),
              AppText(
                'Sign In',
                style: font24w700.copyWith(color: Colors.black),
                alignment: AlignmentDirectional.center,
              ),
              SizedBox(height: 24.h),
              AppText(
                'Email',
                style: font14w500.copyWith(color: const Color(0xff364153)),
              ),
              SizedBox(height: 8.h),
              AppFormField(
                controller: emailController,
                hintText: 'Enter your email',
                maxLines: 1,
                keyboardType: TextInputType.emailAddress,
                prefixIcon: Padding(
                  padding: EdgeInsets.only(left: 8.w),
                  child: Icon(Icons.email_outlined, size: 22.sp),
                ),
                radius: 22.r,
                onChanged: (_) {
                  if (_formSubmitted) {
                    setState(() => _formSubmitted = false);
                    _formKey.currentState?.validate();
                  }
                },
                validator: (value) {
                  if (!_formSubmitted) return null;
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter your email';
                  }

                  return null;
                },
              ),
              SizedBox(height: 16.h),
              AppText(
                'Password',
                style: font14w500.copyWith(color: const Color(0xff364153)),
              ),
              SizedBox(height: 8.h),
              AppFormField(
                controller: passwordController,
                hintText: 'Enter your password',
                maxLines: 1,
                obsecureText: obscurePassword,
                prefixIcon: Padding(
                  padding: EdgeInsets.only(left: 8.w),
                  child: Icon(Icons.lock_outline, size: 22.sp),
                ),
                radius: 22.r,
                suffixIcon: IconButton(
                  icon: Icon(
                    obscurePassword
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                  ),
                  onPressed: () =>
                      setState(() => obscurePassword = !obscurePassword),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }

                  return null;
                },
              ),
              SizedBox(height: 24.h),
              AppButton(
                text: 'Login',
                onPressed: () {
                  setState(() => _formSubmitted = true);
                  if (_formKey.currentState!.validate()) {
                    context.read<LoginCubit>().login(
                      emailController.text.trim(),
                      passwordController.text,
                    );
                  }
                },
                textSize: 16.sp,
                gradient: const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFF0EA5E9), Color(0xFF0284C7)],
                ),
              ),
              SizedBox(height: 18.h),
              AppText(
                'Forgot Password?',
                alignment: AlignmentDirectional.center,
                style: font14w500.copyWith(color: const Color(0xff0EA5E9)),
              ),
              SizedBox(height: 24.h),
              const DividerWidget(),
              SizedBox(height: 24.h),
              BouncingSocialButton(
                text: "Continue with Google",
                assetName: Assets.google,
                onTap: () => context.read<LoginCubit>().loginWithGoogle(),
                textColor: Colors.black,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
