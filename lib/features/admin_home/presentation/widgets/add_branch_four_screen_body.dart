import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:gymbook/core/di/services_locator.dart';
import 'package:gymbook/core/routes/route_paths.dart';
import 'package:gymbook/core/theme/styles.dart';
import 'package:gymbook/core/widgets/custom_button.dart';
import 'package:gymbook/core/widgets/custom_text.dart';
import 'package:gymbook/features/admin_home/data/repositories/admin_branch_repository.dart';
import 'package:gymbook/features/admin_home/presentation/widgets/gym_photos_grid.dart';
import 'package:gymbook/features/admin_home/presentation/widgets/gym_photos_uploader.dart';

import 'package:gymbook/features/auth/presentation/widgets/appbar_auth_card.dart';
import 'package:image_picker/image_picker.dart';

class AddBranchFourScreenBody extends StatefulWidget {
  final int branchId;
  final bool isEditMode;
  final int? imageId;

  const AddBranchFourScreenBody({
    super.key,
    this.branchId = 0,
    this.isEditMode = false,
    this.imageId,
  });

  @override
  State<AddBranchFourScreenBody> createState() =>
      _AddBranchFourScreenBodyState();
}

class _AddBranchFourScreenBodyState extends State<AddBranchFourScreenBody> {
  final ImagePicker _picker = ImagePicker();
  static const int _minImageBytes = 50 * 1024;
  static const int _maxLogos = 1;
  List<File> _gymImages = [];
  bool _isUploading = false;

  /// ================= Pick Branch Logo (max 1) =================
  Future<void> _pickGymImages() async {
    if (_gymImages.length >= _maxLogos) {
      _showLimitMessage();
      return;
    }

    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (image == null) return;

    final pickedFile = File(image.path);
    final fileSize = await pickedFile.length();

    if (!mounted) return;

    if (fileSize < _minImageBytes) {
      _showMessage('Image size is too small. Minimum allowed size is 50 KB.');
      return;
    }

    setState(() {
      _gymImages = [pickedFile];
    });
  }

  void _showLimitMessage() {
    _showMessage('Only one branch logo is allowed');
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Future<int?> _resolveImageId(AdminBranchRepository repository) async {
    if ((widget.imageId ?? 0) > 0) {
      return widget.imageId;
    }

    final branchesResult = await repository.getBranches(
      pageNumber: 1,
      pageSize: 100,
    );

    return branchesResult.fold((_) => null, (response) {
      for (final branch in response.data) {
        if (branch.id == widget.branchId && (branch.logoImageId ?? 0) > 0) {
          return branch.logoImageId;
        }
      }
      return null;
    });
  }

  Future<void> _uploadBranchImages() async {
    if (widget.branchId <= 0) {
      _showMessage('Invalid branch ID. Please go back and try again.');
      return;
    }

    if (_gymImages.isEmpty) {
      _showMessage('Please add at least one image.');
      return;
    }

    setState(() => _isUploading = true);

    final repository = sl<AdminBranchRepository>();
    final effectiveImageId = widget.isEditMode
        ? await _resolveImageId(repository)
        : null;

    final imageFile = _gymImages.first;
    final fileSize = await imageFile.length();
    if (fileSize < _minImageBytes) {
      if (!mounted) return;
      _showMessage('Image size is too small. Minimum allowed size is 50 KB.');
      setState(() => _isUploading = false);
      return;
    }

    final response = widget.isEditMode && (effectiveImageId ?? 0) > 0
        ? await repository.updateBranchImage(
            branchId: widget.branchId,
            imageId: effectiveImageId!,
            imageFile: imageFile,
          )
        : await repository.uploadBranchImage(
            branchId: widget.branchId,
            imageFile: imageFile,
          );

    if (!mounted) return;

    final failed = response.fold((failure) => failure, (_) => null);
    if (failed != null) {
      if (failed.contains('BRANCH_LOGO_ALREADY_EXISTS') ||
          failed.toLowerCase().contains('already has a logo')) {
        _showMessage('This branch already has a logo.');
      } else {
        _showMessage(failed);
      }
      setState(() => _isUploading = false);
      return;
    }

    if (!mounted) return;

    _showMessage(
      widget.isEditMode
          ? 'Image updated successfully'
          : 'Image uploaded successfully',
    );
    setState(() => _isUploading = false);
    if (widget.isEditMode) {
      GoRouter.of(context).pop(true);
    } else {
      GoRouter.of(context).go(Routes.mainNavigationScreen);
    }
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
              'Branch Logo',
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
              '${_gymImages.length} logo selected',
              style: font12w400.copyWith(color: const Color(0xff9CA3AF)),
            ),
            SizedBox(height: 24.h),
            AppButton(
              text: widget.isEditMode ? 'Save Changes' : 'Add Branch',
              onPressed: _isUploading ? null : _uploadBranchImages,
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
