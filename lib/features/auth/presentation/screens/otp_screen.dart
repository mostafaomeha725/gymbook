import 'package:flutter/material.dart';
import 'package:gymbook/features/auth/presentation/screens/widgets/otp_screen_body.dart';

class OtpScreen extends StatelessWidget {
  const OtpScreen({super.key, required this.totalSteps, required this.source});

  final int totalSteps;
  final OtpSource source;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff8f9fa),

      body: OtpScreenBody(totalSteps: totalSteps, source: source),
    );
  }
}

enum OtpSource { customer, business }
