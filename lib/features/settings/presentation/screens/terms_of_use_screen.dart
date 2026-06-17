import 'package:flutter/material.dart';
import 'package:gymbook/features/settings/presentation/widgets/custom_appbar.dart';
import 'package:gymbook/features/settings/presentation/widgets/terms_of_use_screen_body.dart';

class TermsOfUseScreen extends StatelessWidget {
  const TermsOfUseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: TermsOfUseScreenBody(),
    );
  }
}
