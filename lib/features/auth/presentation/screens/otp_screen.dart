import 'package:flutter/material.dart';
import 'package:gymbook/core/enums/app_enums.dart';
import 'package:gymbook/features/auth/presentation/widgets/otp_screen_body.dart';
export 'package:gymbook/core/enums/app_enums.dart' show OtpSource;

class OtpScreen extends StatelessWidget {
  const OtpScreen({super.key, required this.totalSteps, required this.source});

  final int totalSteps;
  final OtpSource source;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: OtpScreenBody(totalSteps: totalSteps, source: source),
    );
  }
}
