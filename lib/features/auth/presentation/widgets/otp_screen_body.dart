import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:gymbook/core/routes/route_paths.dart';
import 'package:gymbook/core/theme/styles.dart';
import 'package:gymbook/core/utils/easy_loading.dart';
import 'package:gymbook/core/widgets/custom_button.dart';
import 'package:gymbook/core/widgets/custom_text.dart';
import 'package:gymbook/features/auth/presentation/cubits/resend_confirmation_email_cubit/resend_confirmation_email_cubit.dart';
import 'package:gymbook/features/auth/presentation/cubits/validate_reset_password_code_cubit/validate_reset_password_code_cubit.dart';
import 'package:gymbook/features/auth/presentation/screens/otp_screen.dart';
import 'package:gymbook/features/auth/presentation/screens/reset_password_screen.dart';
import 'package:gymbook/features/auth/presentation/widgets/appbar_auth_card.dart';
import 'package:gymbook/features/auth/presentation/widgets/auth_icon_badge.dart';
import 'package:gymbook/features/auth/presentation/widgets/pin_code_field.dart';

class OtpScreenBody extends StatefulWidget {
  const OtpScreenBody({
    super.key,
    required this.totalSteps,
    required this.source,
    this.email,
  });

  final int totalSteps;
  final OtpSource source;
  final String? email;

  @override
  State<OtpScreenBody> createState() => _OtpScreenBodyState();
}

class _OtpScreenBodyState extends State<OtpScreenBody> {
  int _secondsRemaining = 120;
  bool canResend = false;
  Timer? _timer;
  String _otpCode = '';

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _secondsRemaining = 120;
    canResend = false;

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining == 0) {
        timer.cancel();
        setState(() {
          canResend = true;
        });
      } else {
        setState(() {
          _secondsRemaining--;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  bool get _canValidateResetCode =>
      widget.source == OtpSource.customer &&
      (widget.email?.trim().isNotEmpty ?? false);

  void _onResendPressed() {
    final email = widget.email?.trim() ?? '';
    if (email.isEmpty) {
      showError('Email is required to resend the code.');
      return;
    }

    context.read<ResendConfirmationEmailCubit>().resendConfirmationEmail(email);
  }

  void _onVerifyPressed() {
    if (_canValidateResetCode) {
      context.read<ValidateResetPasswordCodeCubit>().validateResetPasswordCode(
        email: widget.email!.trim(),
        code: _otpCode,
      );
      return;
    }

    if (widget.source == OtpSource.customer) {
      GoRouter.of(context).pushReplacement(Routes.mainNavigationScreen);
    } else {
      GoRouter.of(context).pushReplacement(Routes.gymRegisterDetailesScreen);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<
          ValidateResetPasswordCodeCubit,
          ValidateResetPasswordCodeState
        >(
          listener: (context, state) {
            if (state is ValidateResetPasswordCodeSuccess) {
              if (_canValidateResetCode) {
                GoRouter.of(context).pushReplacement(
                  Routes.resetPasswordScreen,
                  extra: ResetPasswordScreenArgs(
                    email: widget.email!.trim(),
                    code: _otpCode,
                  ),
                );
                return;
              }

              GoRouter.of(context).pushReplacement(Routes.mainNavigationScreen);
            }
          },
        ),
        BlocListener<
          ResendConfirmationEmailCubit,
          ResendConfirmationEmailState
        >(
          listener: (context, state) {
            if (state is ResendConfirmationEmailSuccess) {
              _startTimer();
            }
          },
        ),
      ],
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: SingleChildScrollView(
          child: Column(
            children: [
              AppbarAuthCard(
                title: 'Verify account',
                currentStep: 2,
                totalSteps: widget.totalSteps,
              ),

              SizedBox(height: 24.h),

              const AuthIconBadge(
                icon: Icons.email_outlined,
                padding: 20,
                iconSize: 42,
              ),

              SizedBox(height: 24.h),

              AppText(
                'Code Verification',
                style: font24w700,
                alignment: AlignmentDirectional.center,
              ),

              SizedBox(height: 8.h),

              AppText(
                'We have sent a verification code to',
                style: font18w500,
                alignment: AlignmentDirectional.center,
              ),

              SizedBox(height: 4.h),

              AppText(
                widget.email?.trim().isNotEmpty == true
                    ? widget.email!.trim()
                    : '+20 123 456 789',
                style: font16w400.copyWith(color: const Color(0xff0EA5E9)),
                alignment: AlignmentDirectional.center,
              ),

              SizedBox(height: 26.h),

              PinCodeField(
                onChanged: (value) {
                  setState(() => _otpCode = value);
                },
                onCompleted: (value) {
                  setState(() => _otpCode = value);
                },
              ),

              SizedBox(height: 16.h),

              AppButton(
                text: 'Verify',
                onPressed: _otpCode.length == 6 ? _onVerifyPressed : null,
                textSize: 18.sp,
                gradient: const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFF0EA5E9), Color(0xFF0284C7)],
                ),
              ),

              SizedBox(height: 20.h),

              AppText(
                "Didn't receive the code?",
                style: font18w400.copyWith(color: const Color(0xff8A8A8A)),
                alignment: AlignmentDirectional.center,
              ),

              SizedBox(height: 8.h),

              GestureDetector(
                onTap: _onResendPressed,
                child: AppText(
                  'Resend Code',
                  style: font18w700.copyWith(
                    color: const Color(0xFF0EA5E9),
                    decoration: TextDecoration.underline,
                    decorationColor: const Color(0xFF0EA5E9),
                  ),
                  alignment: AlignmentDirectional.center,
                ),
              ),

              SizedBox(height: 6.h),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AppText(
                    'Resend timer: ',
                    style: font16w400.copyWith(color: const Color(0xff8A8A8A)),
                  ),
                  AppText(
                    '$_secondsRemaining s',
                    style: font16w500.copyWith(color: const Color(0xFF0EA5E9)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
