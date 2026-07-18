import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:gymbook/core/routes/route_paths.dart';
import 'package:gymbook/features/admin/admin_home/domain/entities/subscription_item_entity.dart';
import 'package:gymbook/features/admin/admin_home/presentation/cubits/branch_subscriptions_list_cubit/branch_subscriptions_list_cubit.dart';
import 'package:gymbook/features/admin/admin_home/presentation/widgets/admin_subscription_card.dart';

class SubscriptionsListWidget extends StatefulWidget {
  final List<SubscriptionItemEntity> items;
  final bool isFetchingMore;

  const SubscriptionsListWidget({
    super.key,
    required this.items,
    this.isFetchingMore = false,
  });

  @override
  State<SubscriptionsListWidget> createState() =>
      _SubscriptionsListWidgetState();
}

class _SubscriptionsListWidgetState extends State<SubscriptionsListWidget> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (!mounted || !_scrollController.hasClients) return;
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.8) {
      context.read<BranchSubscriptionsListCubit>().loadMore();
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<BranchSubscriptionsListCubit>();
    final items = widget.items;

    return RefreshIndicator(
      onRefresh: () async {
        cubit.refresh();
      },
      child: ListView.separated(
        controller: _scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.symmetric(
          horizontal: 0.w,
          vertical: 8.h,
        ).copyWith(bottom: 100.h),
        itemCount: items.length + (widget.isFetchingMore ? 1 : 0),
        separatorBuilder: (_, __) => SizedBox(height: 12.h),
        itemBuilder: (context, index) {
          if (index == items.length) {
            return Padding(
              padding: EdgeInsets.symmetric(vertical: 16.h),
              child: const Center(child: CircularProgressIndicator()),
            );
          }
          final sub = items[index];
          return AdminSubscriptionCard(
            onTap: () async {
              final changed = await GoRouter.of(context).push<bool>(
                Routes.adminSubscriptionDetailsScreen,
                extra: sub.subscriptionId,
              );
              if (changed == true && context.mounted) {
                cubit.refresh();
              }
            },
            name: sub.fullName,
            status: sub.status.displayName,
            totalDays: sub.totalDurationInDays,
            remainingDays: sub.remainingDurationInDays,
          );
        },
      ),
    );
  }
}
