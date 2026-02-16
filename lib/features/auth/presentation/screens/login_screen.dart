import 'package:flutter/material.dart';
import 'package:gymbook/features/auth/presentation/screens/widgets/login_screen_body.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xfff8f9fa),

      body: LoginScreenBody(),
    );
  }
}
