import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gymbook/core/widgets/custom_nav_bar.dart';
import 'package:gymbook/features/home/presentation/screens/widgets/appbar_subscription_widget.dart';
import 'package:gymbook/features/home/presentation/screens/widgets/subscription_list_view.dart';
import 'package:gymbook/features/home/presentation/screens/widgets/subscription_tabs.dart';

enum SubscriptionTab { active, expired }

class SubscriptionsScreenBody extends StatefulWidget {
  const SubscriptionsScreenBody({super.key});

  @override
  State<SubscriptionsScreenBody> createState() =>
      _SubscriptionsScreenBodyState();
}

class _SubscriptionsScreenBodyState extends State<SubscriptionsScreenBody> {
  SubscriptionTab selectedTab = SubscriptionTab.active;

  final List<Map<String, dynamic>> activeSubscriptions = [
    {
      "title": "PowerHouse Gym",
      "plan": "Monthly Plan",
      "used": 24,
      "total": 30,
      "daysLeft": 22,
      "image": "https://images.unsplash.com/photo-1558611848-73f7eb4001a1",
    },
    {
      "title": "FitZone Studio",
      "plan": "Weekly Plan",
      "used": 3,
      "total": 8,
      "daysLeft": 5,
      "image": "https://images.unsplash.com/photo-1571902943202-507ec2618e8f",
    },
    {
      "title": "Elite Fitness Center",
      "plan": "3 Months Plan",
      "used": 45,
      "total": 90,
      "daysLeft": 60,
      "image": "https://images.unsplash.com/photo-1583454110551-21f2fa2afe61",
    },
    {
      "title": "Elite Fitness Center",
      "plan": "3 Months Plan",
      "used": 45,
      "total": 90,
      "daysLeft": 60,
      "image": "https://images.unsplash.com/photo-1583454110551-21f2fa2afe61",
    },
    {
      "title": "Elite Fitness Center",
      "plan": "3 Months Plan",
      "used": 45,
      "total": 90,
      "daysLeft": 60,
      "image": "https://images.unsplash.com/photo-1583454110551-21f2fa2afe61",
    },
  ];

  final List<Map<String, dynamic>> expiredSubscriptions = [
    {
      "title": "Elite Fitness Center",
      "plan": "Monthly Plan",
      "used": 30,
      "total": 30,
      "expiredDate": "Jan 15, 2026",
      "image": "https://images.unsplash.com/photo-1583454110551-21f2fa2afe61",
    },
    {
      "title": "Body Balance Gym",
      "plan": "Monthly Plan",
      "used": 28,
      "total": 30,
      "expiredDate": "Dec 20, 2025",
      "image": "https://images.unsplash.com/photo-1558611848-73f7eb4001a1",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 22.w),
      child: Column(
        children: [
          AppbarSubscriptionWidget(
            text: 'My Subscriptions',
            onBack: () {
              CustomNavBar.of(context)?.goBack();
            },
          ),

          SizedBox(height: 16.h),

          /// Tabs
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: SubscriptionTabs(
              selectedTab: selectedTab,
              onChanged: (tab) {
                setState(() {
                  selectedTab = tab;
                });
              },
            ),
          ),

          SizedBox(height: 32.h),

          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: SubscriptionListView(
                selectedTab: selectedTab,
                activeSubscriptions: activeSubscriptions,
                expiredSubscriptions: expiredSubscriptions,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
