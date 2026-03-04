import 'package:flutter/material.dart';
import 'package:gymbook/features/admin_home/presentation/widgets/admin_add_subscription_screen_body.dart';

class AdminAddSubscriptionScreen extends StatelessWidget {
  final int branchId;
  const AdminAddSubscriptionScreen({super.key, required this.branchId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: AdminAddSubscriptionScreenBody(branchId: branchId));
  }
}
