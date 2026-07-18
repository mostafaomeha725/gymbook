import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gymbook/core/theme/styles.dart';
import 'package:gymbook/core/widgets/appbar_subscription_widget.dart';
import 'package:gymbook/core/widgets/custom_text.dart';
import 'package:gymbook/features/admin/admin_home/presentation/cubits/branch_reviews/branch_reviews_cubit.dart';
import 'package:gymbook/core/utils/easy_loading.dart';
import 'package:gymbook/features/admin/admin_home/presentation/widgets/branch_reviews_header_section.dart';
import 'package:gymbook/features/admin/admin_home/presentation/widgets/branch_reviews_list_section.dart';

class AdminBranchReviewsBody extends StatefulWidget {
  final int branchId;
  final String? branchName;

  const AdminBranchReviewsBody({
    super.key,
    required this.branchId,
    this.branchName,
  });

  @override
  State<AdminBranchReviewsBody> createState() => _AdminBranchReviewsBodyState();
}

class _AdminBranchReviewsBodyState extends State<AdminBranchReviewsBody> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    context.read<BranchReviewsCubit>().loadReviews(widget.branchId);
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (!mounted || !_scrollController.hasClients) return;
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.8) {
      context.read<BranchReviewsCubit>().loadMore();
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
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.h),
          child: AppbarSubscriptionWidget(
            text: widget.branchName ?? 'Branch Reviews',
            subtitle: 'Customer feedback and ratings',
          ),
        ),
        Expanded(
          child: BlocListener<BranchReviewsCubit, BranchReviewsState>(
            listener: (context, state) {
              if (state is BranchReviewsLoaded || state is BranchReviewsError) {
                hideLoading();
              }
            },
            child: BlocBuilder<BranchReviewsCubit, BranchReviewsState>(
              builder: (context, state) {
                if (state is BranchReviewsLoading ||
                    state is BranchReviewsInitial) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is BranchReviewsLoaded) {
                  return RefreshIndicator(
                    onRefresh: () async {
                      await context.read<BranchReviewsCubit>().loadReviews(
                        widget.branchId,
                        isRefresh: true,
                      );
                    },
                    child: CustomScrollView(
                      controller: _scrollController,
                      physics: const AlwaysScrollableScrollPhysics(),
                      slivers: [
                        SliverPadding(
                          padding: EdgeInsets.all(24.w).copyWith(bottom: 0),
                          sliver: SliverToBoxAdapter(
                            child: BranchReviewsHeaderSection(
                              branchId: widget.branchId,
                              state: state,
                            ),
                          ),
                        ),
                        BranchReviewsListSection(state: state),
                        if (state.isFetchingMore)
                          SliverToBoxAdapter(
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 16.h),
                              child: const Center(
                                child: CircularProgressIndicator(),
                              ),
                            ),
                          ),
                        SliverToBoxAdapter(child: SizedBox(height: 24.h)),
                      ],
                    ),
                  );
                } else if (state is BranchReviewsError) {
                  return Center(
                    child: AppText(
                      state.message,
                      style: font14w500.copyWith(color: Colors.red),
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ),
      ],
    );
  }
}
