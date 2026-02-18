import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gymbook/core/theme/styles.dart';
import 'package:gymbook/core/widgets/appbar_subscription_widget.dart';
import 'package:gymbook/core/widgets/custom_text.dart';
import 'package:gymbook/core/widgets/custom_nav_bar.dart';
import 'package:gymbook/features/settings/presentation/widgets/profile_card.dart';
import 'package:gymbook/features/settings/presentation/widgets/settings_card.dart';

class SettingsScreenBody extends StatelessWidget {
  const SettingsScreenBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 22.w),
      child: Column(
        children: [
          AppbarSubscriptionWidget(
            text: 'Settings',
            onBack: () {
              CustomNavBar.of(context)?.goBack();
            },
          ),
          SizedBox(height: 20.h),
          const ProfileCard(),

          SizedBox(height: 24.h),
          const SettingsCard(),

          SizedBox(height: 22.h),

          AppText(
            "Version 1.0.0",
            style: font12w400.copyWith(color: Colors.grey),
            alignment: AlignmentDirectional.center,
          ),

          SizedBox(height: 20.h),
        ],
      ),
    );
  }
}
