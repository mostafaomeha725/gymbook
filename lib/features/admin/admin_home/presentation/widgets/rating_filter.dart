import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gymbook/core/theme/styles.dart';
import 'package:gymbook/core/widgets/custom_text.dart';

class RatingFilter extends StatelessWidget {
  final List<String> ratings;
  final String selectedRating;
  final Function(String) onRatingSelected;

  const RatingFilter({
    super.key,
    required this.ratings,
    required this.selectedRating,
    required this.onRatingSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.filter_alt_outlined,
              color: Colors.grey.shade500,
              size: 18.w,
            ),
            SizedBox(width: 8.w),
            AppText(
              'Filter by Rating',
              style: font14w500.copyWith(color: Colors.grey.shade600),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: ratings.map((rating) {
              final isSelected = selectedRating == rating;
              return GestureDetector(
                onTap: () => onRatingSelected(rating),
                child: Container(
                  margin: EdgeInsets.only(right: 8.w),
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 8.h,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected ? const Color(0xFF0EA5E9) : Colors.white,
                    borderRadius: BorderRadius.circular(20.r),
                    border: isSelected
                        ? null
                        : Border.all(color: Colors.grey.shade200),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: const Color(0xFF0EA5E9).withOpacity(0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ]
                        : null,
                  ),
                  child: Row(
                    children: [
                      if (rating != 'All') ...[
                        Icon(
                          Icons.star,
                          color: isSelected
                              ? Colors.white
                              : const Color(0xFFFBBF24),
                          size: 14.w,
                        ),
                        SizedBox(width: 4.w),
                      ],
                      AppText(
                        rating,
                        style: font14w700.copyWith(
                          color: isSelected
                              ? Colors.white
                              : Colors.grey.shade700,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
