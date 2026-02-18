import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gymbook/features/auth/presentation/widgets/all_feature_register_gym.dart';
import 'package:gymbook/features/auth/presentation/widgets/appbar_auth_card.dart';

class GymRegisterDetailsScreenBody extends StatelessWidget {
  const GymRegisterDetailsScreenBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: const Column(
          children: [
            AppbarAuthCard(
              title: 'Gym Registration',
              currentStep: 3,
              totalSteps: 3,
            ),
            AllFeatureRegisterGym(),
          ],
        ),
      ),
    );
  }
}
