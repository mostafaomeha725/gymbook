import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:gymbook/core/routes/route_paths.dart';
import 'package:gymbook/core/theme/styles.dart';
import 'package:gymbook/core/widgets/custom_button.dart';
import 'package:gymbook/core/widgets/custom_text.dart';
import 'package:gymbook/features/admin_home/presentation/screens/widgets/gym_photos_grid.dart';
import 'package:gymbook/features/admin_home/presentation/screens/widgets/gym_photos_uploader.dart';
import 'package:gymbook/features/auth/presentation/screens/widgets/appbar_auth_card.dart';
import 'package:image_picker/image_picker.dart';

class AddBranchFourScreenBody extends StatefulWidget {
  const AddBranchFourScreenBody({super.key});

  @override
  State<AddBranchFourScreenBody> createState() =>
      _AddBranchFourScreenBodyState();
}

class _AddBranchFourScreenBodyState extends State<AddBranchFourScreenBody> {
  final ImagePicker _picker = ImagePicker();
  List<File> _gymImages = [];

  /// ================= Pick Gym Photos (max 6) =================
  Future<void> _pickGymImages() async {
    final List<XFile>? images = await _picker.pickMultiImage(imageQuality: 80);

    if (images == null || images.isEmpty) return;

    final remaining = 6 - _gymImages.length;

    if (remaining <= 0) {
      _showLimitMessage();
      return;
    }

    if (images.length > remaining) {
      _showLimitMessage();
    }

    setState(() {
      _gymImages.addAll(images.take(remaining).map((e) => File(e.path)));
    });
  }

  void _showLimitMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Maximum 6 photos allowed'),
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          children: [
            const AppbarAuthCard(
              title: 'Add Branch',
              subtitle: 'Step 4 of 4: Add Photos',
              currentStep: 4,
              totalSteps: 4,
            ),
            SizedBox(height: 24.h),
            AppText(
              'Gym Photos',
              style: font14w500.copyWith(color: const Color(0xff364153)),
            ),
            SizedBox(height: 12.h),
            GymPhotosUploader(
              onTap: _pickGymImages,
              currentPhotosCount: _gymImages.length,
            ),
            SizedBox(height: 16.h),
            GymPhotosGrid(
              images: _gymImages,
              onRemove: (image) {
                setState(() {
                  _gymImages.remove(image);
                });
              },
            ),
            SizedBox(height: 12.h),
            AppText(
              '${_gymImages.length} photos added',
              style: font12w400.copyWith(color: const Color(0xff9CA3AF)),
            ),
            SizedBox(height: 24.h),
            AppButton(
              text: 'Add Branch',
              onPressed: () {
                GoRouter.of(context).push(Routes.otpScreen);
              },
              textSize: 16.sp,
              contentPadding: EdgeInsets.symmetric(horizontal: 8.w),
              gradient: const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF0EA5E9), Color(0xFF0284C7)],
              ),
            ),
            SizedBox(height: 32.h),
          ],
        ),
      ),
    );
  }
}
