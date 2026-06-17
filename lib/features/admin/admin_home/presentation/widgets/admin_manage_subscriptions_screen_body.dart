import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:gymbook/core/di/services_locator.dart';
import 'package:gymbook/core/routes/route_paths.dart';
import 'package:gymbook/core/theme/styles.dart';
import 'package:gymbook/core/widgets/appbar_subscription_widget.dart';
import 'package:gymbook/core/widgets/custom_search.dart';
import 'package:gymbook/core/widgets/custom_text.dart';
import 'package:gymbook/features/admin/admin_home/presentation/cubits/branch_subscriptions_list_cubit/branch_subscriptions_list_cubit.dart';
import 'package:gymbook/features/admin/admin_home/presentation/widgets/admin_subscription_card.dart';
import 'package:gymbook/features/admin/admin_home/presentation/widgets/branch_buttom.dart';
import 'package:gymbook/features/admin/admin_home/presentation/widgets/custom_segmented_tabs.dart';
import 'package:gymbook/features/customer/customer_home/presentation/widgets/gym_pagination_widget.dart';

class AdminManageSubscriptionsScreenBody extends StatefulWidget {
  final int branchId;
  const AdminManageSubscriptionsScreenBody({super.key, required this.branchId});

  @override
  State<AdminManageSubscriptionsScreenBody> createState() =>
      _AdminManageSubscriptionsScreenBodyState();
}

class _AdminManageSubscriptionsScreenBodyState
    extends State<AdminManageSubscriptionsScreenBody> {
  static const List<String> _tabs = [
    'All',
    'Active',
    'Scheduled',
    'Frozen',
    'Expired',
    'Cancelled',
  ];

  static const List<int?> _tabStatuses = [null, 1, 0, 2, 3, 4];

  int _selectedTab = 0;
  int _currentPage = 1;

  late final BranchSubscriptionsListCubit _cubit;

  final TextEditingController _searchController = TextEditingController();

  int? get _activeStatus => _tabStatuses[_selectedTab];

  String? get _searchText {
    final t = _searchController.text.trim();
    return t.isEmpty ? null : t;
  }

  void _load({bool refresh = false, int? page}) {
    if (refresh) _currentPage = 1;
    if (page != null) _currentPage = page;

    _cubit.loadSubscriptions(
      branchId: widget.branchId,
      pageNumber: _currentPage,
      search: _searchText,
      status: _activeStatus,
    );
  }

  @override
  void initState() {
    super.initState();
    _cubit = sl<BranchSubscriptionsListCubit>();
    _load(refresh: true);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _cubit.close();
    super.dispose();
  }

  String _searchQuery = '';

  void _onSearchChanged(String value) {
    setState(() {
      _searchQuery = value.trim().toLowerCase();
      _currentPage = 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: SingleChildScrollView(
        child: Column(
          children: [
            const AppbarSubscriptionWidget(text: 'Manage Subscriptions'),
            SizedBox(height: 24.h),

            BranchButtom(
              text: 'Add Subscription',
              icon: Icons.add,
              onTap: () async {
                final added = await GoRouter.of(context).push<bool>(
                  Routes.adminAddSubscriptionScreen,
                  extra: widget.branchId,
                );
                if (added == true && mounted) {
                  setState(() => _currentPage = 1);
                  _load(refresh: true);
                }
              },
            ),

            SizedBox(height: 24.h),

            CustomSegmentedTabs(
              tabs: _tabs,
              selectedIndex: _selectedTab,
              onChanged: (index) {
                setState(() {
                  _selectedTab = index;
                  _currentPage = 1;
                });
                _load(refresh: true);
              },
              titleBuilder: (tab) => tab,
            ),

            SizedBox(height: 16.h),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 22.w),
              child: CustomSearch(
                controller: _searchController,
                hintText: 'Search ${_tabs[_selectedTab]} subscriptions...',
                borderColor: Colors.grey.shade300,
                onChanged: _onSearchChanged,
              ),
            ),

            SizedBox(height: 16.h),

            Builder(
              builder: (ctx) {
                final state = ctx.watch<BranchSubscriptionsListCubit>().state;

                if (state is BranchSubscriptionsListLoading) {
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 40.h),
                    child: const Center(
                      child: CircularProgressIndicator.adaptive(),
                    ),
                  );
                }

                if (state is BranchSubscriptionsListFailure) {
                  return Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 32.w,
                      vertical: 40.h,
                    ),
                    child: Column(
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 48.sp,
                          color: Colors.red[300],
                        ),
                        SizedBox(height: 12.h),
                        AppText(
                          state.message,
                          style: font14w500.copyWith(color: Colors.red[400]),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 16.h),
                        TextButton(
                          onPressed: () => _load(refresh: true),
                          child: const Text('Try Again'),
                        ),
                      ],
                    ),
                  );
                }

                if (state is BranchSubscriptionsListSuccess) {
                  // ── Filter by status ──────────────────────────────────
                  var items = state.response.data;
                  if (_activeStatus != null) {
                    items = items
                        .where((s) => s.status.value == _activeStatus)
                        .toList();
                  }
                  // ── Filter by search query ────────────────────────────
                  if (_searchQuery.isNotEmpty) {
                    items = items
                        .where(
                          (s) =>
                              s.fullName.toLowerCase().contains(_searchQuery),
                        )
                        .toList();
                  }

                  if (items.isEmpty) {
                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: 48.h),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.card_membership_outlined,
                              size: 64.sp,
                              color: Colors.grey.shade300,
                            ),
                            SizedBox(height: 16.h),
                            AppText(
                              'No subscriptions found',
                              style: font16w600.copyWith(
                                color: const Color(0xff475569),
                              ),
                              alignment: AlignmentDirectional.center,
                            ),
                            SizedBox(height: 8.h),
                            AppText(
                              _searchQuery.isNotEmpty 
                                  ? 'No subscriptions match your search.'
                                  : 'No subscriptions found for this status.',
                              style: font14w400.copyWith(
                                color: const Color(0xff94A3B8),
                              ),
                              alignment: AlignmentDirectional.center,
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  return Column(
                    children: [
                      ...items.map(
                        (sub) => AdminSubscriptionCard(
                          onTap: () async {
                            final changed = await GoRouter.of(context)
                                .push<bool>(
                                  Routes.adminSubscriptionDetailsScreen,
                                  extra: sub.subscriptionId,
                                );
                            if (changed == true && mounted) {
                              _load(refresh: true);
                            }
                          },
                          name: sub.fullName,
                          status: sub.status.displayName,
                          totalDays: sub.totalDurationInDays,
                          remainingDays: sub.remainingDurationInDays,
                        ),
                      ),
                      SizedBox(height: 24.h),
                      if (state.response.totalPages > 1)
                        GymPaginationWidget(
                          totalPages: state.response.totalPages,
                          currentPage: state.response.currentPage,
                          onPageChanged: (page) {
                            setState(() => _currentPage = page);
                            _load(page: page);
                          },
                        ),
                    ],
                  );
                }

                return const SizedBox.shrink();
              },
            ),

            SizedBox(height: 40.h),
          ],
        ),
      ),
    );
  }
}
