import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gymbook/features/admin_home/presentation/cubits/branch_images_cubit/branch_images_cubit.dart';

class AddBranchFourImageSlotCard extends StatelessWidget {
  final BranchUploadedImageItem? item;
  final VoidCallback onTap;
  final VoidCallback onRemove;
  final String? emptyLabel;

  const AddBranchFourImageSlotCard({
    super.key,
    required this.item,
    required this.onTap,
    required this.onRemove,
    this.emptyLabel,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 170.h,
        decoration: BoxDecoration(
          color: const Color(0xffF9FAFB),
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(color: const Color(0xffD1D5DB)),
        ),
        child: Stack(
          children: [
            Positioned.fill(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(14.r),
                child: () {
                  if (item?.url.trim().isNotEmpty ?? false) {
                    return Image.network(
                      item!.url,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) {
                        return const Center(
                          child: Icon(Icons.broken_image_outlined),
                        );
                      },
                    );
                  }

                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.add_photo_alternate_outlined,
                          size: 30.sp,
                          color: const Color(0xff9CA3AF),
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          emptyLabel ?? 'Tap to add image',
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: const Color(0xff6B7280),
                          ),
                        ),
                      ],
                    ),
                  );
                }(),
              ),
            ),
            if (item != null)
              Positioned(
                top: 6,
                right: 6,
                child: GestureDetector(
                  onTap: onRemove,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.close,
                      size: 14,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            if (item?.isNew == true)
              Positioned(
                top: 8,
                left: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xffFEF3C7),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    'Pending',
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
