import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gymbook/core/di/services_locator.dart';
import 'package:gymbook/features/customer/customer_subscriptions/presentation/cubits/customer_subscriptions_cubit/customer_subscriptions_cubit.dart';
import 'package:gymbook/features/customer/customer_subscriptions/presentation/widgets/subscriptions_screen_body.dart';

class SubscriptionsScreen extends StatelessWidget {
  const SubscriptionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          sl<CustomerSubscriptionsCubit>()..loadSubscriptions(),
      child: const SubscriptionsScreenBody(),
    );
  }
}
