import 'package:flutter/material.dart';
import 'package:gymbook/features/admin_home/presentation/widgets/admin_subscription_details_screen_body.dart';

class AdminSubscriptionDetailsScreen extends StatelessWidget {
  final int subscriptionId;
  const AdminSubscriptionDetailsScreen({
    super.key,
    required this.subscriptionId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AdminSubscriptionDetailsScreenBody(subscriptionId: subscriptionId),
    );
  }
}
