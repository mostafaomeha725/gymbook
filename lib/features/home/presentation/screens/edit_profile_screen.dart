import 'package:flutter/material.dart';
import 'package:gymbook/features/home/presentation/screens/widgets/edit_profile_screen_body.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xfff8f9fa),

      body: EditProfileScreenBody(),
    );
  }
}
