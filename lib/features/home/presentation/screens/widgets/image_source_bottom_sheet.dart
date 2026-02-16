import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:gymbook/core/widgets/custom_text.dart';

class ImageSourceBottomSheet extends StatelessWidget {
  final VoidCallback onCameraTap;
  final VoidCallback onGalleryTap;

  const ImageSourceBottomSheet({
    super.key,
    required this.onCameraTap,
    required this.onGalleryTap,
  });

  static void show(
    BuildContext context, {
    required VoidCallback onCameraTap,
    required VoidCallback onGalleryTap,
  }) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (_) => ImageSourceBottomSheet(
        onCameraTap: onCameraTap,
        onGalleryTap: onGalleryTap,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.camera_alt),
            title: const AppText("Take a photo"),
            onTap: () {
              GoRouter.of(context).pop();
              onCameraTap();
            },
          ),
          ListTile(
            leading: const Icon(Icons.photo_library),
            title: const AppText("Choose from gallery"),
            onTap: () {
              GoRouter.of(context).pop();
              onGalleryTap();
            },
          ),
        ],
      ),
    );
  }
}
