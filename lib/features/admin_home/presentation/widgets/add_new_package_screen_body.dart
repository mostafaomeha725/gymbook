import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gymbook/core/widgets/appbar_subscription_widget.dart';
import 'package:gymbook/features/admin_home/data/models/package_screen_args.dart';
import 'package:gymbook/features/admin_home/presentation/widgets/add_new_package_text_field_body.dart';

class AddNewPackageScreenBody extends StatelessWidget {
  final PackageScreenArgs args;

  const AddNewPackageScreenBody({super.key, required this.args});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: AppbarSubscriptionWidget(
              text: args.isEditMode ? 'Edit Package' : 'Add New Package',
            ),
          ),
          SizedBox(height: 24.h),

          AddNewPackageTextFieldBody(args: args),
        ],
      ),
    );
  }
}
