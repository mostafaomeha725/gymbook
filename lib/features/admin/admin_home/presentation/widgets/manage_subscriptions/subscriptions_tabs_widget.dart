import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gymbook/features/admin/admin_home/presentation/cubits/branch_subscriptions_list_cubit/branch_subscriptions_list_cubit.dart';
import 'package:gymbook/features/admin/admin_home/presentation/widgets/custom_segmented_tabs.dart';

class SubscriptionsTabsWidget extends StatelessWidget {
  const SubscriptionsTabsWidget({super.key});

  static const List<String> tabs = [
    'All',
    'Active',
    'Scheduled',
    'Frozen',
    'Expired',
    'Cancelled',
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<
      BranchSubscriptionsListCubit,
      BranchSubscriptionsListState
    >(
      builder: (context, state) {
        final cubit = context.read<BranchSubscriptionsListCubit>();
        return CustomSegmentedTabs(
          tabs: tabs,
          selectedIndex: cubit.selectedTab,
          onChanged: cubit.changeTab,
          titleBuilder: (tab) => tab,
        );
      },
    );
  }
}
