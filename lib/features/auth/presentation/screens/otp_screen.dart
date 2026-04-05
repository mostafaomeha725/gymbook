import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gymbook/core/enums/app_enums.dart';
import 'package:gymbook/core/di/services_locator.dart';
import 'package:gymbook/features/auth/presentation/cubits/resend_confirmation_email_cubit/resend_confirmation_email_cubit_factory.dart';
import 'package:gymbook/features/auth/presentation/cubits/validate_reset_password_code_cubit/validate_reset_password_code_cubit.dart';
import 'package:gymbook/features/auth/presentation/widgets/otp_screen_body.dart';
export 'package:gymbook/core/enums/app_enums.dart' show OtpSource;

class OtpScreenArgs {
  const OtpScreenArgs({required this.source, this.email});

  final OtpSource source;
  final String? email;
}

class OtpScreen extends StatelessWidget {
  const OtpScreen({
    super.key,
    required this.totalSteps,
    required this.source,
    this.email,
  });

  final int totalSteps;
  final OtpSource source;
  final String? email;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<ValidateResetPasswordCodeCubit>()),
        BlocProvider(create: (_) => buildResendConfirmationEmailCubit()),
      ],
      child: Scaffold(
        body: OtpScreenBody(
          totalSteps: totalSteps,
          source: source,
          email: email,
        ),
      ),
    );
  }
}
