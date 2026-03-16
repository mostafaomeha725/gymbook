import 'package:flutter/material.dart';
import 'package:gymbook/features/customer_subscriptions/presentation/widgets/subscriptions_details_screen_body.dart';

class SubscriptionsDetailsScreen extends StatelessWidget {
  final CustomerSubscriptionDetailsArgs args;

  const SubscriptionsDetailsScreen({super.key, required this.args});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: SubscriptionsDetailsScreenBody(args: args));
  }
}

class CustomerSubscriptionDetailsArgs {
  final int subscriptionId;
  final int status;

  const CustomerSubscriptionDetailsArgs({
    required this.subscriptionId,
    required this.status,
  });
}
