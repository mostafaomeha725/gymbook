import 'package:flutter/material.dart';
import 'package:gymbook/features/customer/customer_home/presentation/widgets/gym_details_screen_body.dart';

class GymDetailsScreen extends StatelessWidget {
  final GymDetailsArgs args;

  const GymDetailsScreen({super.key, required this.args});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: GymDetailsScreenBody(args: args));
  }
}
