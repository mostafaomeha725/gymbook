import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:gymbook/core/routes/route_paths.dart';
import 'package:gymbook/core/widgets/appbar_subscription_widget.dart';
import 'package:gymbook/core/widgets/custom_search.dart';
import 'package:gymbook/features/admin_home/presentation/screens/widgets/admin_subscription_card.dart';
import 'package:gymbook/features/admin_home/presentation/screens/widgets/branch_buttom.dart';
import 'package:gymbook/features/admin_home/presentation/screens/widgets/custom_segmented_tabs.dart';
import 'package:gymbook/features/admin_home/presentation/screens/widgets/grid_view_manage_subscriptions.dart';
import 'package:gymbook/features/home/presentation/screens/widgets/gym_pagination_widget.dart';

class AdminManageSubscriptionsScreenBody extends StatefulWidget {
  const AdminManageSubscriptionsScreenBody({super.key});

  @override
  State<AdminManageSubscriptionsScreenBody> createState() =>
      _AdminManageSubscriptionsScreenBodyState();
}

class _AdminManageSubscriptionsScreenBodyState
    extends State<AdminManageSubscriptionsScreenBody> {
  int selectedTab = 0;
  int _currentSelectedPage = 1;

  final List<String> tabs = ["All", "Available", "Expired", "Freezed"];
  final List<Map<String, dynamic>> subscriptions = [
    {
      "name": "Ahmed Hassan",
      "status": "Available",
      "totalDays": 30,
      "remainingDays": 15,
    },
    {
      "name": "Mohamed Ali",
      "status": "Expired",
      "totalDays": 30,
      "remainingDays": 0,
    },
    {
      "name": "Sara Ahmed",
      "status": "Freezed",
      "totalDays": 30,
      "remainingDays": 20,
    },
  ];

  final TextEditingController searchController = TextEditingController();

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const AppbarSubscriptionWidget(text: 'Manage Subscriptions'),
          SizedBox(height: 24.h),

          const GridViewManageSubscriptions(),
          SizedBox(height: 24.h),

          BranchButtom(
            text: 'Add Subscription',
            icon: Icons.add,
            onTap: () {
              GoRouter.of(context).push(Routes.adminAddSubscriptionScreen);
            },
          ),

          SizedBox(height: 24.h),

          CustomSegmentedTabs(
            tabs: tabs,
            selectedIndex: selectedTab,
            onChanged: (index) {
              setState(() {
                selectedTab = index;
                _currentSelectedPage = 1;
              });
            },
            titleBuilder: (tab) => "Subscriptions ($tab)",
          ),

          SizedBox(height: 16.h),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 22.w),
            child: CustomSearch(
              controller: searchController,
              hintText: "Search ${tabs[selectedTab]} subscriptions...",
              borderColor: Colors.grey.shade300,
              onChanged: (text) {},
            ),
          ),

          SizedBox(height: 16.h),
          Column(
            children: List.generate(subscriptions.length, (index) {
              final sub = subscriptions[index];

              return AdminSubscriptionCard(
                onTap: () {
                  GoRouter.of(
                    context,
                  ).push(Routes.adminSubscriptionDetailsScreen);
                },
                name: sub["name"],
                status: sub["status"],
                totalDays: sub["totalDays"],
                remainingDays: sub["remainingDays"],
              );
            }),
          ),

          SizedBox(height: 24.h),

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
