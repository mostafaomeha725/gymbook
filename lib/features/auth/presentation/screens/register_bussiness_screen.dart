import 'package:flutter/material.dart';
import 'package:gymbook/features/auth/presentation/screens/widgets/register_bussiness_screen_body.dart';

class RegisterBussinessScreen extends StatelessWidget {
  const RegisterBussinessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xfff8f9fa),

      body: RegisterBussinessScreenBody(),
    );
  }
}
