import 'package:flutter/material.dart';
import 'package:gymbook/features/settings/presentation/widgets/change_password_screen_body.dart';

class ChangePasswordScreen extends StatelessWidget {
  const ChangePasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: ChangePasswordScreenBody(),
    );
  }
}
