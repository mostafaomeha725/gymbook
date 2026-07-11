import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gymbook/core/theme/styles.dart';
import 'package:gymbook/core/widgets/custom_text.dart';

class LocationPickerHeader extends StatelessWidget {
  final bool showClearAll;
  final VoidCallback? onClearAll;

  const LocationPickerHeader({
    super.key,
    required this.showClearAll,
    this.onClearAll,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Drag handle
        Container(
          width: 44.w,
          height: 5.h,
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.circular(99.r),
          ),
        ),
        SizedBox(height: 24.h),

        // Header with Title and Clear Button
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                    color: Theme.of(
                      context,
                    ).colorScheme.primary.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.location_on_rounded,
                    size: 20.sp,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                SizedBox(width: 12.w),
                AppText(
                  'Choose Location',
                  style: font18w700.copyWith(color: const Color(0xff1E293B)),
                ),
              ],
            ),
            if (showClearAll && onClearAll != null)
              InkWell(
                onTap: onClearAll,
                borderRadius: BorderRadius.circular(50.r),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 6.h,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(50.r),
                    border: Border.all(color: Colors.red.shade100),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.delete_outline_rounded,
                        color: Colors.red,
                        size: 16.sp,
                      ),
                      SizedBox(width: 4.w),
                      AppText(
                        'Clear All',
                        style: font12w500.copyWith(color: Colors.red),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }
}
