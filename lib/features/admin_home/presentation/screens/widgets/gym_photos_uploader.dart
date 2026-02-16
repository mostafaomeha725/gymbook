import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gymbook/core/theme/styles.dart';
import 'package:gymbook/core/widgets/custom_text.dart';

class GymPhotosUploader extends StatelessWidget {
  final VoidCallback onTap;
  final int maxPhotos;
  final int currentPhotosCount;

  const GymPhotosUploader({
    super.key,
    required this.onTap,
    this.maxPhotos = 6,
    this.currentPhotosCount = 0,
  });

  @override
  Widget build(BuildContext context) {
    if (currentPhotosCount >= maxPhotos) {
      return const SizedBox.shrink();
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 24.h, horizontal: 20.w),
        decoration: BoxDecoration(
          color: const Color(0xffF9FAFB),
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: const Color(0xff0EA5E9), width: 2.w),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.upload_outlined,
              size: 40.sp,
              color: const Color(0xff0EA5E9),
            ),
            SizedBox(height: 12.h),
            AppText(
              'Upload Photos',
              style: font14w500.copyWith(color: const Color(0xff0EA5E9)),
              alignment: AlignmentDirectional.center,
            ),
            SizedBox(height: 4.h),
            AppText(
              'Add multiple photos of your gym',
              style: font12w500.copyWith(color: const Color(0xff9CA3AF)),
              alignment: AlignmentDirectional.center,
            ),
          ],
        ),
      ),
    );
  }
}
