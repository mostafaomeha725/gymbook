import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:gymbook/core/enums/app_enums.dart';
import 'package:gymbook/core/routes/route_paths.dart';
import 'package:gymbook/core/widgets/custom_text.dart';
import 'package:gymbook/features/customer/customer_subscriptions/data/models/customer_subscription_model.dart';
import 'package:gymbook/features/customer/customer_subscriptions/presentation/screens/subscriptions_details_screen.dart';
import 'package:gymbook/features/customer/customer_subscriptions/presentation/widgets/my_subscription_card.dart';

class SubscriptionListView extends StatelessWidget {
  final SubscriptionTab selectedTab;
  final List<CustomerSubscriptionModel> subscriptions;

  const SubscriptionListView({
    super.key,
    required this.selectedTab,
    required this.subscriptions,
  });

  bool _matchesTab(int status) {
    switch (selectedTab) {
      case SubscriptionTab.all:
        return true;
      case SubscriptionTab.scheduled:
        return status == 0;
      case SubscriptionTab.active:
        return status == 1;
      case SubscriptionTab.frozen:
        return status == 2;
      case SubscriptionTab.expired:
        return status == 3;
      case SubscriptionTab.cancelled:
        return status == 4;
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentList = subscriptions.where((item) {
      return _matchesTab(item.status);
    }).toList();

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
        final status = item.status;

        final totalDuration = item.totalDurationInDays;
        final daysLeft = item.daysLeft;
        final sessionsUsed = (totalDuration - daysLeft).clamp(0, totalDuration);
        final isExpired = status == 3;

        return Padding(
          padding: EdgeInsets.only(bottom: isLast ? 152.h : 0),
          child: MySubscriptionCard(
            image: item.branchLogoUrl,
            title: item.branchName,
            plan: item.packageName,
            sessionsUsed: sessionsUsed,
            sessionsTotal: totalDuration,
            daysLeft: isExpired ? null : daysLeft,
            expiredDate: null,
            isExpired: isExpired,
            status: status,
            onTap: () {
              GoRouter.of(context).push(
                Routes.subscriptionsDetailsScreen,
                extra: CustomerSubscriptionDetailsArgs(
                  subscriptionId: item.subscriptionId,
                  status: status,
                ),
              );
            },
          ),
        );
      },
    );
  }
}
