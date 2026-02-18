import 'package:flutter/material.dart';
import 'package:gymbook/features/auth/presentation/widgets/join_us_screen_body.dart';

class JoinUsScreen extends StatelessWidget {
  const JoinUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xfff8f9fa),

      body: JoinUsScreenBody(),
    );
  }
}
