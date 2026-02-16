import 'package:flutter/material.dart';
import 'package:gymbook/features/auth/presentation/screens/widgets/register_cutomer_screen_body.dart';

class RegisterCustomerScreen extends StatelessWidget {
  const RegisterCustomerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xfff8f9fa),

      body: RegisterCutomerScreenBody(),
    );
  }
}
