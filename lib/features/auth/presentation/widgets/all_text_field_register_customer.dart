import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:gymbook/core/routes/route_paths.dart';
import 'package:gymbook/core/theme/light_colors.dart';
import 'package:gymbook/core/utils/easy_loading.dart';
import 'package:gymbook/core/widgets/custom_button.dart';
import 'package:gymbook/features/auth/presentation/screens/otp_screen.dart';
import 'package:gymbook/features/auth/presentation/screens/register_screen.dart';
import 'package:gymbook/features/auth/presentation/cubits/register_cubit/register_cubit.dart';
import 'package:gymbook/features/auth/presentation/utils/auth_validator.dart';
import 'package:gymbook/features/auth/presentation/widgets/labeled_auth_field.dart';
import 'package:gymbook/features/auth/presentation/widgets/password_condition_widget.dart';

class AllTextFieldRegisterCustomer extends StatefulWidget {
  final RegisterType type;

  const AllTextFieldRegisterCustomer({
    super.key,
    this.type = RegisterType.customer,
  });

  @override
  State<AllTextFieldRegisterCustomer> createState() =>
      _AllTextFieldRegisterCustomerState();
}

class _AllTextFieldRegisterCustomerState
    extends State<AllTextFieldRegisterCustomer> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  void _submitRegistration(BuildContext context) {
    final firstName = firstNameController.text.trim();
    final lastName = lastNameController.text.trim();
    final email = emailController.text.trim();
    final phone = phoneController.text.trim();
    final password = passwordController.text;
    final confirmPassword = confirmPasswordController.text;

    final isValid = AuthValidator.validateRegister(
      firstName: firstName,
      lastName: lastName,
      email: email,
      phone: phone,
      password: password,
      confirmPassword: confirmPassword,
    );

    if (isValid) {
      context.read<RegisterCubit>().register(
        firstName: firstName,
        lastName: lastName,
        email: email,
        password: password,
        confirmPassword: confirmPassword,
        phoneNumber: phone,
        isOwner: widget.type == RegisterType.business,
      );
    }
  }

  void _onRegisterSuccess(BuildContext context, RegisterSuccess state) {
    hideLoading();
    showSuccess('Account created successfully!');
    if (!state.user.emailConfirmed) {
      GoRouter.of(context).push(
        Routes.otpScreen,
        extra: OtpScreenArgs(
          source: widget.type == RegisterType.customer
              ? OtpSource.customer
              : OtpSource.business,
          purpose: OtpPurpose.confirmEmail,
          email: emailController.text.trim(),
        ),
      );
    } else {
      GoRouter.of(context).go(Routes.loginScreen);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<RegisterCubit, RegisterState>(
      listener: (context, state) {
        if (state is RegisterSuccess) {
          _onRegisterSuccess(context, state);
        }
      },
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 52.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LabeledAuthField(
              label: 'First Name',
              hintText: 'Enter your first name',
              controller: firstNameController,
              prefixIcon: Icons.person_outline,
            ),
            LabeledAuthField(
              label: 'Last Name',
              hintText: 'Enter your last name',
              controller: lastNameController,
              prefixIcon: Icons.person_outline,
            ),
            LabeledAuthField(
              label: 'Email',
              hintText: 'Enter your email',
              controller: emailController,
              prefixIcon: Icons.email_outlined,
              keyboardType: TextInputType.emailAddress,
            ),
            LabeledAuthField(
              label: 'Phone Number',
              hintText: '+20 XXX XXX XXX',
              controller: phoneController,
              prefixIcon: Icons.phone_outlined,
              keyboardType: TextInputType.phone,
            ),
            LabeledAuthField(
              label: 'Password',
              hintText: 'Create a password',
              controller: passwordController,
              prefixIcon: Icons.lock_outline,
              isPassword: true,
              hasBottomSpacing: false,
            ),
            SizedBox(height: 8.h),
            ValueListenableBuilder<TextEditingValue>(
              valueListenable: passwordController,
              builder: (context, value, child) {
                return PasswordConditionsWidget(password: value.text);
              },
            ),
            SizedBox(height: 16.h),
            LabeledAuthField(
              label: 'Confirm Password',
              hintText: 'Confirm your password',
              controller: confirmPasswordController,
              prefixIcon: Icons.lock_outline,
              isPassword: true,
              hasBottomSpacing: false,
            ),
            SizedBox(height: 24.h),
            AppButton(
              text: 'Continue',
              onPressed: () => _submitRegistration(context),
              textSize: 16.sp,
              gradient: AppLightColors.buttonGradient,
            ),
            SizedBox(height: 24.h),
          ],
        ),
      ),
    );
  }
}
