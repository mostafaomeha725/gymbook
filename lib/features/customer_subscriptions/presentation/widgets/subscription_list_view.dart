import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:gymbook/core/routes/route_paths.dart';
import 'package:gymbook/core/widgets/custom_text.dart';
import 'package:gymbook/features/customer_subscriptions/presentation/widgets/my_subscription_card.dart';
import 'package:gymbook/features/customer_subscriptions/presentation/widgets/subscriptions_screen_body.dart';

class SubscriptionListView extends StatelessWidget {
  final SubscriptionTab selectedTab;
  final List<Map<String, dynamic>> activeSubscriptions;
  final List<Map<String, dynamic>> expiredSubscriptions;

  const SubscriptionListView({
    super.key,
    required this.selectedTab,
    required this.activeSubscriptions,
    required this.expiredSubscriptions,
  });

  @override
  Widget build(BuildContext context) {
    final currentList = selectedTab == SubscriptionTab.active
        ? activeSubscriptions
        : expiredSubscriptions;

    if (currentList.isEmpty) {
      return const Center(
        child: AppText(
          "No subscriptions found",
          alignment: AlignmentDirectional.center,
        ),
      );
    }

    return ListView.separated(
      padding: EdgeInsets.zero,
      itemCount: currentList.length,
      separatorBuilder: (_, __) => 16.verticalSpace,
      itemBuilder: (_, index) {
        final item = currentList[index];
        final isLast = index == currentList.length - 1;

        return Padding(
          padding: EdgeInsets.only(bottom: isLast ? 152.h : 0),
          child: MySubscriptionCard(
            image: item["image"],
            title: item["title"],
            plan: item["plan"],
            sessionsUsed: item["used"],
            sessionsTotal: item["total"],
            daysLeft: selectedTab == SubscriptionTab.active
                ? item["daysLeft"]
                : null,
            expiredDate: selectedTab == SubscriptionTab.expired
                ? item["expiredDate"]
                : null,
            isExpired: selectedTab == SubscriptionTab.expired,
            onTap: () {
              GoRouter.of(context).push(Routes.subscriptionsDetailsScreen);
            },
          ),
        );
      },
    );
  }
}
