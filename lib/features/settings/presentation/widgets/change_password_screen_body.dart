import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gymbook/core/widgets/appbar_subscription_widget.dart';
import 'package:gymbook/features/settings/presentation/widgets/change_password_header.dart';
import 'package:gymbook/features/settings/presentation/widgets/change_password_form.dart';

class ChangePasswordScreenBody extends StatelessWidget {
  const ChangePasswordScreenBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: const AppbarSubscriptionWidget(text: "Change Password"),
          ),
          SizedBox(height: 28.h),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const ChangePasswordHeader(),
                SizedBox(height: 32.h),
                const ChangePasswordForm(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
