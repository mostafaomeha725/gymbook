import 'package:flutter/material.dart';
import 'package:gymbook/features/settings/presentation/widgets/custom_appbar.dart';
import 'package:gymbook/features/settings/presentation/widgets/privacy_policy_screen_body.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: PrivacyPolicyScreenBody(),
    );
  }
}
