import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gymbook/core/widgets/appbar_subscription_widget.dart';

import 'package:gymbook/features/admin_home/presentation/screens/widgets/add_new_package_text_field_body.dart';

class AddNewPackageScreenBody extends StatelessWidget {
  const AddNewPackageScreenBody({super.key});

  @override
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: const AppbarSubscriptionWidget(text: 'Add New Package'),
          ),
          SizedBox(height: 24.h),

          const AddNewPackageTextFieldBody(),
        ],
      ),
    );
  }
}
