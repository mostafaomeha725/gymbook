// --- تصميم معرض الصور (Gallery) ---
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gymbook/core/theme/styles.dart';
import 'package:gymbook/core/widgets/app_asset.dart';
import 'package:gymbook/core/widgets/custom_text.dart';
import 'package:gymbook/features/home/presentation/screens/widgets/more_image_grid.dart';

class GymGallery extends StatelessWidget {
  final String selectedImage;
  final Function(String) onImageTap;
  final bool isCompact;
  final List<String> allImages;

  const GymGallery({
    super.key,
    required this.selectedImage,
    required this.onImageTap,
    required this.allImages,
    this.isCompact = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isCompact) {
      const maxVisible = 3;
      final showExtra = allImages.length > maxVisible;
      final visibleImages = showExtra
          ? allImages.sublist(0, maxVisible)
          : allImages;
      final remainingCount = allImages.length - maxVisible;

      return SizedBox(
        height: 70.h,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.symmetric(horizontal: 60.w),
          itemCount: visibleImages.length + (showExtra ? 1 : 0),
          separatorBuilder: (_, __) => SizedBox(width: 10.w),
          itemBuilder: (context, index) {
            if (index < visibleImages.length) {
              final isSelected = selectedImage == visibleImages[index];
              return GestureDetector(
                onTap: () => onImageTap(visibleImages[index]),
                child: Container(
                  padding: EdgeInsets.all(2.w),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14.r),
                    border: isSelected
                        ? Border.all(color: const Color(0xff0284C7), width: 2.w)
                        : null,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12.r),
                    child: AppAsset(
                      assetName: visibleImages[index],
                      width: 60.w,
                      height: 60.h,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              );
            } else {
              return GestureDetector(
                onTap: () => _showMore(context),
                child: Container(
                  width: 60.w,
                  height: 60.h,
                  decoration: BoxDecoration(
                    color: const Color(0xff0284C7),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  alignment: Alignment.center,
                  child: AppText(
                    '+$remainingCount',
                    style: font14w500.copyWith(color: Colors.white),
                    alignment: AlignmentDirectional.center,
                  ),
                ),
              );
            }
          },
        ),
      );
    }

    return SizedBox(
      height: 80.h,
      child: ListView.separated(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        scrollDirection: Axis.horizontal,
        itemCount: allImages.length,
        separatorBuilder: (_, __) => SizedBox(width: 8.w),
        itemBuilder: (context, index) {
          final isSelected = allImages[index] == selectedImage;
          return GestureDetector(
            onTap: () => onImageTap(allImages[index]),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(
                  color: isSelected
                      ? const Color(0xff0284C7)
                      : Colors.transparent,
                  width: 2.w,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.r),
                child: AppAsset(
                  assetName: allImages[index],
                  width: 60.w,
                  height: 60.h,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _showMore(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      builder: (_) => MoreImagesGrid(images: allImages, onImageTap: onImageTap),
    );
  }
}
