import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:gymbook/core/routes/route_paths.dart';
import 'package:gymbook/features/auth/presentation/screens/otp_screen.dart';
import 'package:gymbook/features/auth/presentation/cubits/forget_password_cubit/forget_password_cubit.dart';
import 'package:gymbook/features/auth/presentation/widgets/appbar_auth_card.dart';
import 'package:gymbook/features/auth/presentation/widgets/forget_password_form_section.dart';

class ForgetPasswordScreenBody extends StatefulWidget {
  const ForgetPasswordScreenBody({super.key});

  @override
  State<ForgetPasswordScreenBody> createState() =>
      _ForgetPasswordScreenBodyState();
}

class _ForgetPasswordScreenBodyState extends State<ForgetPasswordScreenBody> {
  final TextEditingController emailController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _formSubmitted = false;

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  void _onSubmit() {
    setState(() => _formSubmitted = true);
    if (!_formKey.currentState!.validate()) return;

    context.read<ForgetPasswordCubit>().sendResetPasswordEmail(
      emailController.text.trim(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ForgetPasswordCubit, ForgetPasswordState>(
      listener: (context, state) {
        if (state is ForgetPasswordSuccess) {
          GoRouter.of(context).push(
            Routes.otpScreen,
            extra: OtpScreenArgs(
              source: OtpSource.customer,
              email: emailController.text.trim(),
            ),
          );
        }
      },
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: const AppbarAuthCard(
                title: 'Forgot Password',
                subtitle: 'Enter your email to receive a reset code',
                currentStep: 1,
                totalSteps: 3,
              ),
            ),
            ForgetPasswordFormSection(
              formKey: _formKey,
              emailController: emailController,
              formSubmitted: _formSubmitted,
              onSubmit: _onSubmit,
              onEmailChanged: (_) {
                if (_formSubmitted) {
                  _formKey.currentState?.validate();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
