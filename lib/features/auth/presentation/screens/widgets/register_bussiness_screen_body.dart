import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:gymbook/features/auth/presentation/screens/widgets/all_text_field_register_bussiness.dart';
import 'package:gymbook/features/auth/presentation/screens/widgets/appbar_auth_card.dart';

class RegisterBussinessScreenBody extends StatelessWidget {
  const RegisterBussinessScreenBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 32.w),
      child: Column(
        children: [
          const AppbarAuthCard(
            title: 'Gym Registration',
            currentStep: 1,
            totalSteps: 3,
          ),
          SizedBox(height: 24.h),

          const AllTextFieldRegisterBussiness(),
        ],
      ),
    );
  }
}
