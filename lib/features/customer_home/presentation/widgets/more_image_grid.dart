import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:gymbook/core/widgets/app_asset.dart';

class MoreImagesGrid extends StatelessWidget {
  final List<String> images;
  final Function(String) onImageTap;
  const MoreImagesGrid({
    super.key,
    required this.images,
    required this.onImageTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: GridView.builder(
        itemCount: images.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 10.w,
          mainAxisSpacing: 10.h,
        ),
        itemBuilder: (context, index) => GestureDetector(
          onTap: () {
            onImageTap(images[index]);
            context.pop();
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12.r),
            child: AppAsset(assetName: images[index], fit: BoxFit.cover),
          ),
        ),
      ),
    );
  }
}
