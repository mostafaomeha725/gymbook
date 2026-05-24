import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ExistingBranchImageItem {
  final int id;
  final String url;

  const ExistingBranchImageItem({required this.id, required this.url});
}

class GymPhotosGrid extends StatelessWidget {
  final List<ExistingBranchImageItem> existingImages;
  final List<File> newImages;
  final ValueChanged<File>? onRemoveNew;
  final ValueChanged<ExistingBranchImageItem>? onRemoveExisting;

  const GymPhotosGrid({
    super.key,
    this.existingImages = const [],
    this.newImages = const [],
    this.onRemoveNew,
    this.onRemoveExisting,
  });

  @override
  Widget build(BuildContext context) {
    if (existingImages.isEmpty && newImages.isEmpty) {
      return const SizedBox.shrink();
    }

    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 12.w,
      mainAxisSpacing: 12.h,
      childAspectRatio: 1,
      children: [
        ...existingImages.map(
          (image) => Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12.r),
                child: Image.network(
                  image.url,
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) {
                    return Container(
                      color: const Color(0xffF3F4F6),
                      alignment: Alignment.center,
                      child: const Icon(Icons.broken_image_outlined),
                    );
                  },
                ),
              ),
              if (onRemoveExisting != null)
                Positioned(
                  top: 4,
                  right: 4,
                  child: GestureDetector(
                    onTap: () => onRemoveExisting!.call(image),
                    child: Container(
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.red,
                      ),
                      padding: const EdgeInsets.all(4),
                      child: const Icon(
                        Icons.close,
                        size: 14,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
        ...newImages.map(
          (image) => Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.r),
                  image: DecorationImage(
                    image: FileImage(image),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              if (onRemoveNew != null)
                Positioned(
                  top: 4,
                  right: 4,
                  child: GestureDetector(
                    onTap: () => onRemoveNew!.call(image),
                    child: Container(
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.red,
                      ),
                      padding: const EdgeInsets.all(4),
                      child: const Icon(
                        Icons.close,
                        size: 14,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
