import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gymbook/core/theme/styles.dart';
import 'package:gymbook/core/widgets/custom_text.dart';
import 'package:gymbook/features/admin/admin_home/domain/entities/review_entity.dart';
import 'package:gymbook/features/admin/admin_home/presentation/widgets/get_type_color.dart';

class ReviewCard extends StatelessWidget {
  final ReviewEntity review;

  const ReviewCard({super.key, required this.review});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10.r,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 24.r,
                backgroundColor: GetTypeColor().getAvatarColor(review.initials),
                child: AppText(
                  review.initials ?? '',
                  style: font14w700.copyWith(
                    color: GetTypeColor().getTextColor(review.initials),
                  ),
                  alignment: AlignmentDirectional.center,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(
                      review.authorName,
                      style: font18w700.copyWith(color: Colors.black),
                    ),
                    Row(
                      children: [
                        Row(
                          children: List.generate(
                            5,
                            (index) => Icon(
                              index < review.rating
                                  ? Icons.star
                                  : Icons.star_border,
                              color: index < review.rating
                                  ? const Color(0xFFFBBF24)
                                  : Colors.grey.shade300,
                              size: 16.w,
                            ),
                          ),
                        ),
                        SizedBox(width: 8.w),
                        AppText(
                          review.timeAgo,
                          style: font12w400.copyWith(
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          AppText(
            review.content,
            style: font14w500.copyWith(
              color: Colors.grey.shade700,
              height: 1.5,
            ),
            maxLines: 6,
          ),
        ],
      ),
    );
  }
}
