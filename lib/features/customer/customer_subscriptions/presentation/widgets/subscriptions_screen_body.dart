import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gymbook/core/enums/app_enums.dart'
    show SubscriptionTab, SubscriptionTabExtension;
import 'package:gymbook/core/widgets/appbar_subscription_widget.dart';
import 'package:gymbook/core/widgets/custom_text.dart';
import 'package:gymbook/core/widgets/custom_nav_bar.dart';
import 'package:gymbook/features/customer/customer_subscriptions/presentation/cubits/customer_subscriptions_cubit/customer_subscriptions_cubit.dart';
import 'package:gymbook/features/customer/customer_subscriptions/presentation/cubits/customer_subscriptions_cubit/customer_subscriptions_state.dart';
import 'package:gymbook/features/customer/customer_subscriptions/presentation/widgets/subscription_list_view.dart';
import 'package:gymbook/features/customer/customer_subscriptions/presentation/widgets/subscription_tabs.dart';

class SubscriptionsScreenBody extends StatefulWidget {
  const SubscriptionsScreenBody({super.key});

  @override
  State<SubscriptionsScreenBody> createState() =>
      _SubscriptionsScreenBodyState();
}

class _SubscriptionsScreenBodyState extends State<SubscriptionsScreenBody> {
  SubscriptionTab selectedTab = SubscriptionTab.all;
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
      context.read<CustomerSubscriptionsCubit>().loadMore(
        status: selectedTab.backendStatus,
      );
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
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 22.w),
      child: Column(
        children: [
          AppbarSubscriptionWidget(
            text: 'My Subscriptions',
            onBack: () {
              CustomNavBar.of(context)?.goBack();
            },
          ),
          SizedBox(height: 16.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: SubscriptionTabs(
              selectedTab: selectedTab,
              onChanged: (tab) {
                setState(() {
                  selectedTab = tab;
                });
                context.read<CustomerSubscriptionsCubit>().loadSubscriptions(
                  status: tab.backendStatus,
                );
              },
            ),
          ),
          SizedBox(height: 8.h),
          Expanded(
            child:
                BlocBuilder<
                  CustomerSubscriptionsCubit,
                  CustomerSubscriptionsState
                >(
                  builder: (context, state) {
                    if (state is CustomerSubscriptionsLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is CustomerSubscriptionsError) {
                      return Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            AppText(state.message),
                            SizedBox(height: 12.h),
                            ElevatedButton(
                              onPressed: () {
                                context
                                    .read<CustomerSubscriptionsCubit>()
                                    .loadSubscriptions(
                                      status: selectedTab.backendStatus,
                                    );
                              },
                              child: const Text('Retry'),
                            ),
                          ],
                        ),
                      );
                    } else if (state is CustomerSubscriptionsLoaded) {
                      return RefreshIndicator(
                        onRefresh: () async {
                          await context
                              .read<CustomerSubscriptionsCubit>()
                              .loadSubscriptions(
                                status: selectedTab.backendStatus,
                                refresh: true,
                              );
                        },
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          child: SubscriptionListView(
                            scrollController: _scrollController,
                            physics: const AlwaysScrollableScrollPhysics(),
                            selectedTab: selectedTab,
                            subscriptions: state.items,
                            paginationWidget: state.isFetchingMore
                                ? const Center(
                                    child: CircularProgressIndicator(),
                                  )
                                : null,
                          ),
                        ),
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
