import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:gymbook/core/routes/route_paths.dart';
import 'package:gymbook/core/theme/styles.dart';
import 'package:gymbook/core/widgets/appbar_subscription_widget.dart';
import 'package:gymbook/core/widgets/custom_text.dart';
import 'package:gymbook/features/admin_home/presentation/widgets/branch_buttom.dart';
import 'package:gymbook/features/admin_home/presentation/widgets/manage_package_status.dart';
import 'package:gymbook/features/admin_home/presentation/widgets/package_card.dart';
import 'package:gymbook/features/home/presentation/widgets/gym_pagination_widget.dart';

class ManagePackageScreenBody extends StatefulWidget {
  final int branchId;

  const ManagePackageScreenBody({super.key, required this.branchId});

  @override
  State<ManagePackageScreenBody> createState() =>
      _ManagePackageScreenBodyState();
}

class _ManagePackageScreenBodyState extends State<ManagePackageScreenBody> {
  int _currentSelectedPage = 1;

  List<Map<String, dynamic>> packages = [
    {
      "title": "Premium Semi-Annual",
      "months": 6,
      "freezes": 3,
      "price": "2500",
      "isActive": true,
    },
    {
      "title": "Elite Annual",
      "months": 12,
      "freezes": 4,
      "price": "4500",
      "isActive": false,
    },
    {
      "title": "Starter Monthly",
      "months": 1,
      "freezes": 1,
      "price": "500",
      "isActive": true,
    },
  ];

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

          BranchButtom(
            text: 'Add New Package',
            icon: Icons.add,
            onTap: () {
              GoRouter.of(
                context,
              ).push(Routes.addNewPackageScreen, extra: widget.branchId);
            },
          ),

          SizedBox(height: 48.h),

          AppText(
            'All Packages',
            style: font18w700,
            textPadding: EdgeInsets.symmetric(horizontal: 22.w),
          ),

          SizedBox(height: 16.h),

          ...List.generate(packages.length, (index) {
            final pkg = packages[index];

            return PackageCard(
              onEdit: () {
                GoRouter.of(
                  context,
                ).push(Routes.addNewPackageScreen, extra: widget.branchId);
              },
              title: pkg["title"],
              months: pkg["months"],
              freezes: pkg["freezes"],
              price: pkg["price"],
              isActive: pkg["isActive"],

              sideColor: pkg["isActive"] ? Colors.green : Colors.red,

              onToggle: (value) {
                setState(() {
                  pkg["isActive"] = value;
                });
              },
            );
          }),

          SizedBox(height: 20.h),

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
