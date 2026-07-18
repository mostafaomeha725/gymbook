import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:gymbook/core/routes/route_paths.dart';
import 'package:gymbook/core/widgets/appbar_subscription_widget.dart';
import 'package:gymbook/core/utils/easy_loading.dart';
import 'package:gymbook/features/admin/admin_home/presentation/cubits/branch_subscriptions_list_cubit/branch_subscriptions_list_cubit.dart';
import 'package:gymbook/features/admin/admin_home/presentation/widgets/branch_buttom.dart';
import 'package:gymbook/features/admin/admin_home/presentation/widgets/manage_subscriptions/subscriptions_empty_widget.dart';
import 'package:gymbook/features/admin/admin_home/presentation/widgets/manage_subscriptions/subscriptions_error_widget.dart';
import 'package:gymbook/features/admin/admin_home/presentation/widgets/manage_subscriptions/subscriptions_list_widget.dart';
import 'package:gymbook/features/admin/admin_home/presentation/widgets/manage_subscriptions/subscriptions_search_widget.dart';
import 'package:gymbook/features/admin/admin_home/presentation/widgets/manage_subscriptions/subscriptions_tabs_widget.dart';

class AdminManageSubscriptionsScreenBody extends StatelessWidget {
  final int branchId;

  const AdminManageSubscriptionsScreenBody({super.key, required this.branchId});

  @override
  Widget build(BuildContext context) {
    return BlocListener<
      BranchSubscriptionsListCubit,
      BranchSubscriptionsListState
    >(
      listener: (context, state) {
        if (state is BranchSubscriptionsListSuccess ||
            state is BranchSubscriptionsListFailure) {
          hideLoading();
        }
      },
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.h),
            child: const AppbarSubscriptionWidget(text: 'Manage Subscriptions'),
          ),
          SizedBox(height: 24.h),

          BranchButtom(
            text: 'Add Subscription',
            icon: Icons.add,
            onTap: () async {
              final added = await GoRouter.of(
                context,
              ).push<bool>(Routes.adminAddSubscriptionScreen, extra: branchId);
              if (added == true && context.mounted) {
                context.read<BranchSubscriptionsListCubit>().refresh();
              }
            },
          ),

          SizedBox(height: 24.h),

          const SubscriptionsTabsWidget(),

          SizedBox(height: 16.h),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 22.w),
            child: const SubscriptionsSearchWidget(),
          ),

          SizedBox(height: 16.h),

          Expanded(
            child:
                BlocBuilder<
                  BranchSubscriptionsListCubit,
                  BranchSubscriptionsListState
                >(
                  builder: (ctx, state) {
                    if (state is BranchSubscriptionsListLoading) {
                      return Padding(
                        padding: EdgeInsets.symmetric(vertical: 40.h),
                        child: const Center(
                          child: CircularProgressIndicator.adaptive(),
                        ),
                      );
                    }

                    if (state is BranchSubscriptionsListFailure) {
                      return SubscriptionsErrorWidget(message: state.message);
                    }

                    if (state is BranchSubscriptionsListSuccess) {
                      if (state.response.data.isEmpty) {
                        final hasSearch =
                            ctx
                                .read<BranchSubscriptionsListCubit>()
                                .searchText !=
                            null;
                        return SubscriptionsEmptyWidget(hasSearch: hasSearch);
                      }

                      return SubscriptionsListWidget(
                        items: state.items,
                        isFetchingMore: state.isFetchingMore,
                      );
                    }

                    return const SizedBox.shrink();
                  },
                ),
          ),
        ],
      ),
    );
  }
}
