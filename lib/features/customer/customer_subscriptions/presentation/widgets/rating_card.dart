import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gymbook/core/di/services_locator.dart';
import 'package:gymbook/core/theme/styles.dart';
import 'package:gymbook/core/widgets/app_form_field.dart';
import 'package:gymbook/core/widgets/custom_button.dart';
import 'package:gymbook/core/widgets/custom_text.dart';
import 'package:gymbook/core/widgets/custom_snack_bar.dart';
import 'package:gymbook/features/customer/customer_subscriptions/presentation/cubits/add_review_cubit/add_review_cubit.dart';
import 'package:gymbook/features/customer/customer_subscriptions/presentation/cubits/add_review_cubit/add_review_state.dart';

class RatingCard extends StatefulWidget {
  final int branchId;
  const RatingCard({super.key, required this.branchId});

  @override
  State<RatingCard> createState() => _RatingCardState();
}

class _RatingCardState extends State<RatingCard> {
  int selectedRating = 0;
  final TextEditingController _controller = TextEditingController();
  late AddReviewCubit _addReviewCubit;

  @override
  void initState() {
    super.initState();
    _addReviewCubit = sl<AddReviewCubit>();
  }

  @override
  void dispose() {
    _controller.dispose();
    _addReviewCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _addReviewCubit,
      child: BlocConsumer<AddReviewCubit, AddReviewState>(
        listener: (context, state) {
          if (state is AddReviewSuccess) {
            CustomSnackBar.showSuccess(
              context,
              message: 'Review submitted successfully',
            );
          } else if (state is AddReviewUpdated) {
            CustomSnackBar.showSuccess(
              context,
              message: 'Review updated successfully',
            );
          } else if (state is AddReviewError) {
            CustomSnackBar.showError(context, message: state.message);
          }
        },
        builder: (context, state) {
          final cubit = context.read<AddReviewCubit>();
          final isLoading = state is AddReviewLoading;
          final hasReview = cubit.hasReview;

          return Container(
            padding: EdgeInsets.all(20.w),
            margin: EdgeInsets.symmetric(horizontal: 24.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 20.r,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  hasReview ? "Update Your Review" : "Rate Your Experience",
                  style: font18w700.copyWith(color: const Color(0xff2E3A46)),
                ),

                SizedBox(height: 20.h),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (index) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedRating = index + 1;
                        });
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 6.w),
                        child: Icon(
                          index < selectedRating
                              ? Icons.star
                              : Icons.star_border,
                          color: const Color(0xffF5C518),
                          size: 40.sp,
                        ),
                      ),
                    );
                  }),
                ),

                SizedBox(height: 24.h),

                AppFormField(
                  controller: _controller,
                  hintText: "Share your experience (optional)",
                  maxLines: 4,
                  minLines: 4,
                  fillColor: const Color(0xffF5F7FA),
                  radius: 16.r,
                  borderWidth: 1,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 16.h,
                  ),
                ),

                SizedBox(height: 28.h),

                AppButton(
                  text: isLoading
                      ? (hasReview ? 'Updating...' : 'Submitting...')
                      : (hasReview ? 'Update Review' : 'Submit Review'),
                  textSize: 16.sp,
                  onPressed: isLoading
                      ? null
                      : () {
                          if (selectedRating == 0) {
                            CustomSnackBar.showError(
                              context,
                              message: 'Please select a rating first',
                            );
                            return;
                          }
                          _addReviewCubit.submitReview(
                            branchId: widget.branchId,
                            rating: selectedRating,
                            comment: _controller.text,
                          );
                        },
                  color: const Color(0xFF0EA5E9),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
