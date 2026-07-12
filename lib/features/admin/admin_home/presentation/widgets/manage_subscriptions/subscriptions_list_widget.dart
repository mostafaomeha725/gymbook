import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:gymbook/core/routes/route_paths.dart';
import 'package:gymbook/features/admin/admin_home/domain/entities/subscription_item_entity.dart';
import 'package:gymbook/features/admin/admin_home/presentation/cubits/branch_subscriptions_list_cubit/branch_subscriptions_list_cubit.dart';
import 'package:gymbook/features/admin/admin_home/presentation/widgets/admin_subscription_card.dart';
import 'package:gymbook/features/customer/customer_home/presentation/widgets/gym_pagination_widget.dart';

class SubscriptionsListWidget extends StatelessWidget {
  final SubscriptionsListEntity response;

  const SubscriptionsListWidget({super.key, required this.response});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<BranchSubscriptionsListCubit>();
    final items = response.data;

    return ListView.separated(
      padding: EdgeInsets.symmetric(horizontal: 0.w, vertical: 8.h)
          .copyWith(bottom: 100.h),
      itemCount: response.totalPages > 1 ? items.length + 1 : items.length,
      separatorBuilder: (_, __) => SizedBox(height: 12.h),
      itemBuilder: (context, index) {
        if (index == items.length) {
          return GymPaginationWidget(
            totalPages: response.totalPages,
            currentPage: response.currentPage,
            onPageChanged: cubit.changePage,
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
    );
  }
}
