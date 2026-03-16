import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:gymbook/core/di/services_locator.dart';
import 'package:gymbook/features/admin_home/presentation/cubits/cancel_subscription_cubit/cancel_subscription_cubit.dart';
import 'package:gymbook/features/admin_home/presentation/cubits/cancel_subscription_cubit/cancel_subscription_state.dart';
import 'package:gymbook/features/admin_home/presentation/cubits/freeze_subscription_cubit/freeze_subscription_cubit.dart';
import 'package:gymbook/features/admin_home/presentation/cubits/freeze_subscription_cubit/freeze_subscription_state.dart';
import 'package:gymbook/features/admin_home/presentation/cubits/subscription_details_cubit/subscription_details_cubit.dart';
import 'package:gymbook/features/admin_home/presentation/cubits/subscription_details_cubit/subscription_details_state.dart';

import 'package:gymbook/features/admin_home/presentation/widgets/details_content.dart';

class AdminSubscriptionDetailsScreenBody extends StatelessWidget {
  final int subscriptionId;
  const AdminSubscriptionDetailsScreenBody({
    super.key,
    required this.subscriptionId,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) =>
              sl<SubscriptionDetailsCubit>()..loadDetails(subscriptionId),
        ),
        BlocProvider(create: (_) => sl<CancelSubscriptionCubit>()),
        BlocProvider(create: (_) => sl<FreezeSubscriptionCubit>()),
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<CancelSubscriptionCubit, CancelSubscriptionState>(
            listener: (context, state) {
              if (state is CancelSubscriptionLoading) {
                EasyLoading.show(status: 'Cancelling...');
              } else if (state is CancelSubscriptionSuccess) {
                EasyLoading.dismiss();
                GoRouter.of(context).pop(true);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Subscription cancelled successfully'),
                    backgroundColor: Colors.green,
                  ),
                );
              } else if (state is CancelSubscriptionFailure) {
                EasyLoading.dismiss();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
          ),
          BlocListener<FreezeSubscriptionCubit, FreezeSubscriptionState>(
            listener: (context, state) {
              if (state is FreezeSubscriptionLoading) {
                EasyLoading.show(status: 'Processing...');
              } else if (state is FreezeSubscriptionSuccess) {
                EasyLoading.dismiss();
                context.read<SubscriptionDetailsCubit>().loadDetails(
                  subscriptionId,
                );
              } else if (state is FreezeSubscriptionFailure) {
                EasyLoading.dismiss();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
          ),
        ],
        child: BlocBuilder<SubscriptionDetailsCubit, SubscriptionDetailsState>(
          builder: (context, state) {
            if (state is SubscriptionDetailsLoading ||
                state is SubscriptionDetailsInitial) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is SubscriptionDetailsFailure) {
              return Center(
                child: Text(
                  state.message,
                  style: const TextStyle(color: Colors.red),
                ),
              );
            }
            if (state is SubscriptionDetailsSuccess) {
              return DetailsContent(details: state.details);
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
