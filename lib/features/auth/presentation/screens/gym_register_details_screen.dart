import 'package:flutter/material.dart';
import 'package:gymbook/features/auth/presentation/screens/widgets/gym_register_details_screen_body.dart';

class GymRegisterDetailsScreen extends StatelessWidget {
  const GymRegisterDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xfff8f9fa),

      body: GymRegisterDetailsScreenBody(),
    );
  }
}
