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
import 'package:gymbook/features/auth/presentation/screens/otp_screen.dart';
import 'package:gymbook/features/auth/presentation/cubits/login_cubit/login_cubit.dart';
import 'package:gymbook/features/auth/presentation/utils/auth_validator.dart';
import 'package:gymbook/features/auth/presentation/widgets/divider_widget.dart';
import 'package:gymbook/features/auth/presentation/widgets/role_selection_widget.dart';

class LoginWidget extends StatefulWidget {
  const LoginWidget({super.key});

  @override
  State<LoginWidget> createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool obscurePassword = true;
  int selectedUserType =
      4; // Default to Customer (4), PartnerAdmin (2), Employee (3)

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
            extra: state.loginResult.user.isAdmin,
          );
        } else if (state is LoginEmailNotVerified) {
          hideLoading();
          GoRouter.of(context).push(
            Routes.otpScreen,
            extra: OtpScreenArgs(
              source: selectedUserType == 2
                  ? OtpSource.business
                  : OtpSource.customer,
              purpose: OtpPurpose.confirmEmail,
              email: emailController.text.trim(),
            ),
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
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppText(
              'Sign In',
              style: font24w700.copyWith(color: Colors.black),
              alignment: AlignmentDirectional.center,
            ),
            SizedBox(height: 8.h),
            AppText(
              'Choose your role',
              style: font14w500.copyWith(color: const Color(0xff64748B)),
            ),
            SizedBox(height: 16.h),
            RoleSelectionWidget(
              selectedRole: selectedUserType,
              onChanged: (value) => setState(() => selectedUserType = value),
            ),
            SizedBox(height: 24.h),
            const DividerWidget(),
            SizedBox(height: 16.h),
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
            ),
            SizedBox(height: 24.h),
            AppButton(
              text: 'Login',
              onPressed: () {
                final email = emailController.text.trim();
                final password = passwordController.text;

                final isValid = AuthValidator.validateLogin(
                  email: email,
                  password: password,
                );

                if (isValid) {
                  context.read<LoginCubit>().login(
                    email,
                    password,
                    selectedUserType,
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
            GestureDetector(
              onTap: () =>
                  GoRouter.of(context).push(Routes.forgetPasswordScreen),
              child: AppText(
                'Forgot Password?',
                alignment: AlignmentDirectional.center,
                style: font14w500.copyWith(color: const Color(0xff0EA5E9)),
              ),
            ),
            SizedBox(height: 16.h),
            const DividerWidget(),
            SizedBox(height: 16.h),
            BouncingSocialButton(
              text: "Continue with Google",
              assetName: Assets.google,
              onTap: () =>
                  context.read<LoginCubit>().loginWithGoogle(selectedUserType),
              textColor: Colors.black,
            ),
          ],
        ),
      ),
    );
  }
}
