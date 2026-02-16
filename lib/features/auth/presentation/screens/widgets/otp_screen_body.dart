import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:gymbook/core/routes/route_paths.dart';
import 'package:gymbook/core/theme/styles.dart';
import 'package:gymbook/core/widgets/custom_button.dart';
import 'package:gymbook/core/widgets/custom_text.dart';
import 'package:gymbook/features/auth/presentation/screens/otp_screen.dart';
import 'package:gymbook/features/auth/presentation/screens/widgets/appbar_auth_card.dart';
import 'package:gymbook/features/auth/presentation/screens/widgets/pin_code_field.dart';

class OtpScreenBody extends StatefulWidget {
  const OtpScreenBody({
    super.key,
    required this.totalSteps,
    required this.source,
  });

  final int totalSteps;
  final OtpSource source;

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

  /// ✅ هنا المنطق الصح
  void _onVerifyPressed() {
    if (widget.source == OtpSource.customer) {
      GoRouter.of(context).pushReplacement(Routes.mainNavigationScreen);
    } else {
      GoRouter.of(context).pushReplacement(Routes.gymRegisterDetailesScreen);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
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

            Container(
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFF0EA5E9), Color(0xFF0284C7)],
                ),
              ),
              child: Padding(
                padding: EdgeInsets.all(20.h),
                child: Icon(
                  Icons.email_outlined,
                  color: Colors.white,
                  size: 42.sp,
                ),
              ),
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
              '+20 123 456 789',
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

            canResend
                ? GestureDetector(
                    onTap: _startTimer,
                    child: AppText(
                      'Resend Code',
                      style: font18w400.copyWith(
                        color: const Color(0xFF0EA5E9),
                      ),
                      alignment: AlignmentDirectional.center,
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AppText(
                        'Resend after ',
                        style: font18w400.copyWith(
                          color: const Color(0xff8A8A8A),
                        ),
                      ),
                      AppText(
                        '$_secondsRemaining',
                        style: font18w400.copyWith(
                          color: const Color(0xFF0EA5E9),
                        ),
                      ),
                      AppText(
                        ' s',
                        style: font18w400.copyWith(
                          color: const Color(0xff8A8A8A),
                        ),
                      ),
                    ],
                  ),
          ],
        ),
      ),
    );
  }
}
