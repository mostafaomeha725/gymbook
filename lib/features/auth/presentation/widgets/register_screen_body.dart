import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gymbook/features/auth/presentation/screens/register_screen.dart';
import 'package:gymbook/features/auth/presentation/widgets/all_text_field_register_customer.dart';
import 'package:gymbook/features/auth/presentation/widgets/appbar_auth_card.dart';

class RegisterScreenBody extends StatelessWidget {
  final RegisterType type;

  const RegisterScreenBody({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    final isCustomer = type == RegisterType.customer;

    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: isCustomer ? 24.w : 32.w),
            child: AppbarAuthCard(
              title: isCustomer ? 'Create Account' : 'Gym Registration',
              currentStep: 1,
              totalSteps: isCustomer ? 2 : 3,
            ),
          ),
          SizedBox(height: 24.h),
          if (isCustomer)
            const AllTextFieldRegisterCustomer()
          else
            const AllTextFieldRegisterCustomer(type: RegisterType.business),
        ],
      ),
    );
  }
}
