import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gymbook/core/theme/styles.dart';
import 'package:gymbook/core/widgets/app_form_field.dart';
import 'package:gymbook/core/widgets/custom_button.dart';
import 'package:gymbook/core/widgets/custom_text.dart';

class RatingCard extends StatefulWidget {
  const RatingCard({super.key});

  @override
  State<RatingCard> createState() => _RatingCardState();
}

class _RatingCardState extends State<RatingCard> {
  int selectedRating = 0;
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
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
          /// Title
          AppText(
            "Rate Your Experience",
            style: font18w700.copyWith(color: const Color(0xff2E3A46)),
          ),

          SizedBox(height: 20.h),

          /// Stars
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
                    index < selectedRating ? Icons.star : Icons.star_border,
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
            text: 'Submit Review',
            textSize: 16.sp,
            onPressed: () {},
            color: const Color(0xFF0EA5E9),
          ),
        ],
      ),
    );
  }
}
