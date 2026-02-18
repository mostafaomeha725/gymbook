import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gymbook/core/widgets/appbar_subscription_widget.dart';
import 'package:gymbook/core/widgets/bouncing_social_button.dart';
import 'package:gymbook/features/admin_home/presentation/widgets/package_select_card.dart';
import 'package:gymbook/features/admin_home/presentation/widgets/subscription_summary_card.dart';
import 'package:gymbook/features/admin_home/presentation/widgets/user_detail_form.dart';
import 'package:gymbook/features/admin_home/presentation/widgets/user_type_selector.dart';


class AdminAddSubscriptionScreenBody extends StatefulWidget {
  const AdminAddSubscriptionScreenBody({super.key});

  @override
  State<AdminAddSubscriptionScreenBody> createState() =>
      _AdminAddSubscriptionScreenBodyState();
}

class _AdminAddSubscriptionScreenBodyState
    extends State<AdminAddSubscriptionScreenBody> {
  int selectedUserType = 0;

  int selectedPackage = 0;

  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();

  final List<Map<String, dynamic>> packages = [
    {
      "title": "Basic Monthly",
      "duration": "1m",
      "price": "500",
      "freezes": "1",
      "icon": Icons.inventory_2_outlined,
    },
    {
      "title": "Standard Quarterly",
      "duration": "3m",
      "price": "1350",
      "freezes": "2",
      "icon": Icons.inventory_2_outlined,
    },
    {
      "title": "Basic Monthly",
      "duration": "1m",
      "price": "500",
      "freezes": "1",
      "icon": Icons.inventory_2_outlined,
    },
    {
      "title": "Standard Quarterly",
      "duration": "3m",
      "price": "1350",
      "freezes": "2",
      "icon": Icons.inventory_2_outlined,
    },
  ];

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const AppbarSubscriptionWidget(text: 'Add Subscription'),
          SizedBox(height: 24.h),

          UserTypeSelector(
            selectedIndex: selectedUserType,
            onChanged: (i) => setState(() => selectedUserType = i),
          ),

          SizedBox(height: 24.h),

          UserDetailsForm(
            nameController: nameController,
            phoneController: phoneController,
            emailController: emailController,
            isExistingUser: selectedUserType == 1,
          ),

          SizedBox(height: 24.h),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 22.w),
            child: Column(
              children: List.generate(packages.length, (index) {
                final pkg = packages[index];

                return Padding(
                  padding: EdgeInsets.only(bottom: 12.h),
                  child: PackageSelectCard(
                    title: pkg["title"],
                    duration: pkg["duration"],
                    price: pkg["price"],
                    freezes: pkg["freezes"],
                    icon: pkg["icon"],
                    isActive: selectedPackage == index,
                    onTap: () {
                      setState(() => selectedPackage = index);
                    },
                  ),
                );
              }),
            ),
          ),
          SizedBox(height: 12.h),
          SubscriptionSummaryCard(
            planName: packages[selectedPackage]["title"],
            price: packages[selectedPackage]["price"],
          ),

          SizedBox(height: 24.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 22.w),
            child: BouncingSocialButton(
              text: 'Add Subscription',

              textSize: 16.sp,
              icon: Icons.check,
              gradient: const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF0EA5E9), Color(0xFF0284C7)],
              ),
            ),
          ),
          SizedBox(height: 40.h),
        ],
      ),
    );
  }
}
