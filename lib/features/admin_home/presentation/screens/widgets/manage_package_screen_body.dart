import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gymbook/core/theme/styles.dart';
import 'package:gymbook/core/widgets/custom_text.dart';
import 'package:gymbook/features/admin_home/presentation/screens/widgets/branch_buttom.dart';
import 'package:gymbook/features/admin_home/presentation/screens/widgets/manage_package_status.dart';
import 'package:gymbook/features/admin_home/presentation/screens/widgets/package_card.dart';
import 'package:gymbook/features/home/presentation/screens/widgets/appbar_subscription_widget.dart';
import 'package:gymbook/features/home/presentation/screens/widgets/gym_pagination_widget.dart';

class ManagePackageScreenBody extends StatefulWidget {
  const ManagePackageScreenBody({super.key});

  @override
  State<ManagePackageScreenBody> createState() =>
      _ManagePackageScreenBodyState();
}

class _ManagePackageScreenBodyState extends State<ManagePackageScreenBody> {
  int _currentSelectedPage = 1;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: const AppbarSubscriptionWidget(text: 'Manage Packages'),
          ),
          SizedBox(height: 24.h),

          const ManagePackageStatus(),
          SizedBox(height: 24.h),

          BranchButtom(text: 'Add New Package', icon: Icons.add, onTap: () {}),

          SizedBox(height: 48.h),

          AppText(
            'All Packages',
            style: font18w700,
            textPadding: EdgeInsets.symmetric(horizontal: 22.w),
          ),

          SizedBox(height: 16.h),

          PackageCard(
            title: "Premium Semi-Annual",
            months: 6,
            freezes: 3,
            price: "2500",
            isActive: true,
            sideColor: Colors.green,
            onToggle: (v) {},
          ),

          PackageCard(
            title: "Elite Annual",
            months: 12,
            freezes: 4,
            price: "4500",
            isActive: false,
            sideColor: Colors.red,
            onToggle: (v) {},
          ),
          PackageCard(
            title: "Elite Annual",
            months: 12,
            freezes: 4,
            price: "4500",
            isActive: false,
            sideColor: Colors.red,
            onToggle: (v) {},
          ),
          PackageCard(
            title: "Elite Annual",
            months: 12,
            freezes: 4,
            price: "4500",
            isActive: false,
            sideColor: Colors.red,
            onToggle: (v) {},
          ),

          SizedBox(height: 20.h),

          GymPaginationWidget(
            totalPages: 3,
            currentPage: _currentSelectedPage,
            onPageChanged: (page) {
              setState(() {
                _currentSelectedPage = page;
              });
            },
          ),

          SizedBox(height: 40.h),
        ],
      ),
    );
  }
}
