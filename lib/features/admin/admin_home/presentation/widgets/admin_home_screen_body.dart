import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gymbook/core/services/notification_refresh_service.dart';
import 'package:gymbook/core/theme/styles.dart';
import 'package:gymbook/core/widgets/custom_text.dart';
import 'package:gymbook/features/admin/admin_home/presentation/cubits/branches_list_cubit/branches_list_cubit.dart';
import 'package:gymbook/features/admin/admin_home/presentation/cubits/branches_list_cubit/branches_list_state.dart';
import 'package:gymbook/features/admin/admin_home/presentation/widgets/branches_list_view.dart';
import 'package:gymbook/core/utils/easy_loading.dart';
import 'package:gymbook/features/customer/customer_home/presentation/widgets/appbar_admin_home_widget.dart';

class AdminHomeScreenBody extends StatefulWidget {
  const AdminHomeScreenBody({super.key});

  @override
  State<AdminHomeScreenBody> createState() => _AdminHomeScreenBodyState();
}

class _AdminHomeScreenBodyState extends State<AdminHomeScreenBody> {
  StreamSubscription<int>? _refreshSubscription;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    // Auto-refresh branch list on BranchUpdate (type 1) notification
    _refreshSubscription = NotificationRefreshService().stream.listen((type) {
      if (type == 1 && mounted) {
        context.read<BranchesListCubit>().loadBranches(refresh: true);
      }
    });
  }

  void _onScroll() {
    if (!mounted || !_scrollController.hasClients) return;
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.8) {
      context.read<BranchesListCubit>().loadMore();
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _refreshSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<BranchesListCubit, BranchesListState>(
      listener: (context, state) {
        if (state is BranchesListSuccess || state is BranchesListFailure) {
          hideLoading();
        }
      },
      child: BlocBuilder<BranchesListCubit, BranchesListState>(
        builder: (context, state) {
          return Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: AppbarAdminHomeWidget(
                  userName: 'My Branches',
                  location: 'Manage all your gym locations',
                  onSearchChanged: (value) => context
                      .read<BranchesListCubit>()
                      .loadBranches(search: value),
                  onAddBranchClosed: () => context
                      .read<BranchesListCubit>()
                      .loadBranches(refresh: true),
                ),
              ),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () => context
                      .read<BranchesListCubit>()
                      .loadBranches(refresh: true),
                  child: CustomScrollView(
                    controller: _scrollController,
                    physics: const AlwaysScrollableScrollPhysics(),
                    slivers: [
                      SliverToBoxAdapter(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 16.h),
                            if (state is BranchesListSuccess)
                              AppText(
                                'All Branches (${state.response.totalCount})',
                                style: font20w700,
                                textPadding: EdgeInsets.symmetric(
                                  horizontal: 22.w,
                                ),
                              )
                            else
                              AppText(
                                'All Branches',
                                style: font20w700,
                                textPadding: EdgeInsets.symmetric(
                                  horizontal: 22.w,
                                ),
                              ),
                            SizedBox(height: 16.h),
                          ],
                        ),
                      ),
                      if (state is BranchesListLoading)
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: EdgeInsets.only(top: 60.h),
                            child: const Center(
                              child: CircularProgressIndicator(),
                            ),
                          ),
                        )
                      else if (state is BranchesListFailure)
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 16.w,
                              vertical: 60.h,
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
                                  style: font14w500.copyWith(
                                    color: Colors.red[400],
                                  ),
                                ),
                                SizedBox(height: 16.h),
                                TextButton(
                                  onPressed: () => context
                                      .read<BranchesListCubit>()
                                      .loadBranches(refresh: true),
                                  child: const Text('Try Again'),
                                ),
                              ],
                            ),
                          ),
                        )
                      else if (state is BranchesListSuccess)
                        BranchesListView(
                          branches: state.items,
                          isFetchingMore: state.isFetchingMore,
                        ),
                      SliverToBoxAdapter(child: SizedBox(height: 120.h)),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
