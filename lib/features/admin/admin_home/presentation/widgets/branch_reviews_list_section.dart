import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gymbook/features/admin/admin_home/presentation/cubits/branch_reviews/branch_reviews_cubit.dart';
import 'package:gymbook/features/admin/admin_home/presentation/widgets/review_card.dart';

class BranchReviewsListSection extends StatelessWidget {
  final BranchReviewsLoaded state;

  const BranchReviewsListSection({
    super.key,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            return Padding(
              padding: EdgeInsets.only(bottom: 16.h),
              child: ReviewCard(review: state.reviews[index]),
            );
          },
          childCount: state.reviews.length,
        ),
      ),
    );
  }
}
