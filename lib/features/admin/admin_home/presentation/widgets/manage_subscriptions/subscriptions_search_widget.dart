import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gymbook/core/widgets/custom_search.dart';
import 'package:gymbook/features/admin/admin_home/presentation/cubits/branch_subscriptions_list_cubit/branch_subscriptions_list_cubit.dart';
import 'package:gymbook/features/admin/admin_home/presentation/widgets/manage_subscriptions/subscriptions_tabs_widget.dart';

class SubscriptionsSearchWidget extends StatefulWidget {
  const SubscriptionsSearchWidget({super.key});

  @override
  State<SubscriptionsSearchWidget> createState() =>
      _SubscriptionsSearchWidgetState();
}

class _SubscriptionsSearchWidgetState extends State<SubscriptionsSearchWidget> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<
      BranchSubscriptionsListCubit,
      BranchSubscriptionsListState
    >(
      builder: (context, state) {
        final cubit = context.read<BranchSubscriptionsListCubit>();
        final currentTabName = SubscriptionsTabsWidget.tabs[cubit.selectedTab];

        return CustomSearch(
          controller: _searchController,
          hintText: 'Search $currentTabName subscriptions...',
          borderColor: Colors.grey.shade300,
          onChanged: cubit.onSearchChanged,
          onSubmitted: cubit.onSearchSubmitted,
        );
      },
    );
  }
}
