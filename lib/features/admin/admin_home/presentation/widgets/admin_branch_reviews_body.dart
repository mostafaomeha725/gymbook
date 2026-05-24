import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gymbook/core/theme/styles.dart';
import 'package:gymbook/core/widgets/appbar_subscription_widget.dart';
import 'package:gymbook/core/widgets/custom_text.dart';
import 'package:gymbook/features/admin/admin_home/presentation/cubits/branch_reviews/branch_reviews_cubit.dart';
import 'package:gymbook/features/admin/admin_home/presentation/widgets/rating_filter.dart';
import 'package:gymbook/features/admin/admin_home/presentation/widgets/review_card.dart';
import 'package:gymbook/features/customer/customer_home/presentation/widgets/gym_pagination_widget.dart';

class AdminBranchReviewsBody extends StatefulWidget {
  final int branchId;

  const AdminBranchReviewsBody({super.key, required this.branchId});

  @override
  State<AdminBranchReviewsBody> createState() => _AdminBranchReviewsBodyState();
}

class _AdminBranchReviewsBodyState extends State<AdminBranchReviewsBody> {
  @override
  void initState() {
    super.initState();
    context.read<BranchReviewsCubit>().loadReviews(widget.branchId);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.h),
          child: const AppbarSubscriptionWidget(
            text: 'Wolves gym',
            subtitle: 'Customer feedback and ratings',
          ),
        ),
        Expanded(
          child: BlocBuilder<BranchReviewsCubit, BranchReviewsState>(
            builder: (context, state) {
              if (state is BranchReviewsLoading ||
                  state is BranchReviewsInitial) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is BranchReviewsLoaded) {
                return ListView(
                  padding: EdgeInsets.all(24.w),
                  children: [
                    RatingFilter(
                      ratings: const ['All', '5', '4', '3', '2', '1'],
                      selectedRating: state.selectedRating,
                      onRatingSelected: (rating) {
                        context.read<BranchReviewsCubit>().filterByRating(
                          rating,
                        );
                      },
                    ),
                    SizedBox(height: 24.h),
                    Row(
                      children: [
                        AppText(
                          state.averageRating.toString(),
                          style: font20w700.copyWith(
                            color: const Color(0xFF0EA5E9),
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Row(
                          children: List.generate(
                            5,
                            (index) => Icon(
                              index < state.averageRating.floor()
                                  ? Icons.star
                                  : (index < state.averageRating
                                        ? Icons.star_half
                                        : Icons.star_border),
                              color: const Color(0xFFFBBF24),
                              size: 18.w,
                            ),
                          ),
                        ),
                        SizedBox(width: 8.w),
                        AppText(
                          '(${state.totalCount})',
                          style: font14w500.copyWith(
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16.h),
                    ...state.reviews.map(
                      (review) => ReviewCard(review: review),
                    ),
                    SizedBox(height: 16.h),
                    if (state.totalPages > 1)
                      GymPaginationWidget(
                        totalPages: state.totalPages,
                        currentPage: state.currentPage,
                        onPageChanged: (page) {
                          context.read<BranchReviewsCubit>().changePage(page);
                        },
                      ),
                  ],
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
      ],
    );
  }
}
