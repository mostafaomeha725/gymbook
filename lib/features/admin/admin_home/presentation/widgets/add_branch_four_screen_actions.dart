import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:gymbook/core/routes/route_paths.dart';
import 'package:gymbook/core/utils/easy_loading.dart';
import 'package:gymbook/features/admin/admin_home/presentation/cubits/branch_images_cubit/branch_images_cubit.dart';
import 'package:gymbook/features/admin/admin_home/presentation/cubits/branch_setup_cubit/branch_setup_cubit.dart';
import 'package:image_picker/image_picker.dart';

class AddBranchFourScreenActions {
  const AddBranchFourScreenActions._();

  static Future<void> pickLogo({
    required BuildContext context,
    required ImagePicker picker,
    required int branchId,
  }) async {
    final picked = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );
    if (picked == null || !context.mounted) return;

    await context.read<BranchImagesCubit>().replaceOrAddAtIndex(
      branchId: branchId,
      index: BranchImagesCubit.logoSlotIndex,
      file: File(picked.path),
    );
  }

  static Future<void> pickMultipleMarketplaceImages({
    required BuildContext context,
    required ImagePicker picker,
    required int branchId,
  }) async {
    final picked = await picker.pickMultiImage(imageQuality: 85);
    if (picked.isEmpty || !context.mounted) return;

    final files = picked.map((item) => File(item.path)).toList();
    context.read<BranchImagesCubit>().addMarketplaceImagesSequentially(
      branchId: branchId,
      files: files,
    );
  }

  static Future<void> pickForSlot({
    required BuildContext context,
    required ImagePicker picker,
    required int branchId,
    required int index,
  }) async {
    final picked = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );
    if (picked == null || !context.mounted) return;

    await context.read<BranchImagesCubit>().replaceOrAddAtIndex(
      branchId: branchId,
      index: index,
      file: File(picked.path),
    );
  }

  static void showMessage({
    required BuildContext context,
    required String message,
  }) {
    showError(message);
  }

  static void handleSetupStateChanges({
    required BuildContext context,
    required BranchSetupState setupState,
    required bool isEditMode,
    required int? fallbackLogoImageId,
    required String? fallbackLogoUrl,
  }) {
    if (setupState.errorMessage != null &&
        setupState.errorMessage!.isNotEmpty) {
      showMessage(context: context, message: setupState.errorMessage!);
    }

    if (isEditMode && setupState.details != null) {
      context.read<BranchImagesCubit>().initializeFromExisting(
        existingImages: setupState.details!.images,
        fallbackLogoImageId: fallbackLogoImageId,
        fallbackLogoUrl: fallbackLogoUrl,
      );
    }
  }

  static void handleImagesStateChanges({
    required BuildContext context,
    required BranchImagesState imagesState,
    required bool isEditMode,
  }) {
    final isBusy = imagesState.isUploading || imagesState.isSaving;
    if (isBusy) {
      showLoading(
        status: imagesState.isSaving
            ? 'Saving images...'
            : 'Uploading images...',
      );
    } else {
      hideLoading();
    }

    if (imagesState.errorMessage != null &&
        imagesState.errorMessage!.isNotEmpty) {
      showMessage(context: context, message: imagesState.errorMessage!);
    }

    if (imagesState.successMessage != null &&
        imagesState.successMessage!.isNotEmpty) {
      showSuccess(imagesState.successMessage!);
    }

    if (imagesState.activationSuccess) {
      if (isEditMode) {
        GoRouter.of(context).pop(true);
      } else {
        GoRouter.of(context).go(Routes.mainNavigationScreen);
      }
    }

    context.read<BranchImagesCubit>().clearTransientState();
  }
}
