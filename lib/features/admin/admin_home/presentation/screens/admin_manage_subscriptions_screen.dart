import 'package:flutter/material.dart';
import 'package:gymbook/features/admin/admin_home/presentation/widgets/admin_manage_subscriptions_screen_body.dart';

class AdminManageSubscriptionsScreen extends StatelessWidget {
  final int branchId;
  const AdminManageSubscriptionsScreen({super.key, required this.branchId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AdminManageSubscriptionsScreenBody(branchId: branchId),
    );
  }
}
