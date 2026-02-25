import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gymbook/core/widgets/appbar_subscription_widget.dart';
import 'package:gymbook/features/admin_home/presentation/widgets/add_new_package_text_field_body.dart';

class AddNewPackageScreenBody extends StatelessWidget {
  final int branchId;

  const AddNewPackageScreenBody({super.key, required this.branchId});

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

          AddNewPackageTextFieldBody(branchId: branchId),
        ],
      ),
    );
  }
}
