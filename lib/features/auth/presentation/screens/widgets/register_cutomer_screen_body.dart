import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gymbook/features/auth/presentation/screens/widgets/all_text_field_register_customer.dart';
import 'package:gymbook/features/auth/presentation/screens/widgets/appbar_auth_card.dart';

class RegisterCutomerScreenBody extends StatelessWidget {
  const RegisterCutomerScreenBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: const AppbarAuthCard(
              title: 'Create Account',
              currentStep: 1,
              totalSteps: 2,
            ),
          ),
          SizedBox(height: 24.h),
          const AllTextFieldRegisterCustomer(),
        ],
      ),
    );
  }
}
