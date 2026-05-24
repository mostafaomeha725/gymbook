import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:gymbook/features/admin/admin_home/domain/entities/branch_setup_details_entity.dart';
import 'package:gymbook/features/admin/admin_home/domain/entities/uploaded_branch_image_entity.dart';
import 'package:gymbook/features/admin/admin_home/domain/usecases/activate_branch_images_usecase.dart';
import 'package:gymbook/features/admin/admin_home/domain/usecases/upload_branch_image_usecase.dart';

part 'branch_images_state.dart';

class BranchImagesCubit extends Cubit<BranchImagesState> {
  static const int logoSlotIndex = 0;
  static const int firstMarketplaceSlotIndex = 1;
  static const int lastMarketplaceSlotIndex = BranchImagesState.maxImages - 1;

  BranchImagesCubit({
    required this.uploadBranchImageUseCase,
    required this.activateBranchImagesUseCase,
  }) : super(
         BranchImagesState(
           slots: List<BranchUploadedImageItem?>.filled(
             BranchImagesState.maxImages,
             null,
           ),
         ),
       );

  final UploadBranchImageUseCase uploadBranchImageUseCase;
  final ActivateBranchImagesUseCase activateBranchImagesUseCase;

  void initializeFromExisting({
    required List<BranchSetupImageEntity> existingImages,
    int? fallbackLogoImageId,
    String? fallbackLogoUrl,
  }) {
    if (state.isInitialized) return;

    final workingSlots = List<BranchUploadedImageItem?>.from(state.slots);

    final logo = existingImages.where((item) => item.type == 0).toList();
    logo.sort((a, b) => a.displayOrder.compareTo(b.displayOrder));

    if (logo.isNotEmpty) {
      final logoItem = logo.first;
      if (logoItem.id > 0 && logoItem.url.trim().isNotEmpty) {
        workingSlots[logoSlotIndex] = BranchUploadedImageItem(
          id: logoItem.id,
          url: logoItem.url,
          imageType: 0,
          displayOrder: logoSlotIndex + 1,
          isNew: false,
        );
      }
    }

    if (workingSlots[logoSlotIndex] == null &&
        (fallbackLogoImageId ?? 0) > 0 &&
        (fallbackLogoUrl ?? '').trim().isNotEmpty) {
      workingSlots[logoSlotIndex] = BranchUploadedImageItem(
        id: fallbackLogoImageId!,
        url: fallbackLogoUrl!.trim(),
        imageType: 0,
        displayOrder: logoSlotIndex + 1,
        isNew: false,
      );
    }

    final marketPlace = existingImages.where((item) => item.type == 1).toList()
      ..sort((a, b) => a.displayOrder.compareTo(b.displayOrder));

    var slot = firstMarketplaceSlotIndex;
    for (final image in marketPlace) {
      if (slot > lastMarketplaceSlotIndex) break;
      if (image.id <= 0 || image.url.trim().isEmpty) continue;

      workingSlots[slot] = BranchUploadedImageItem(
        id: image.id,
        url: image.url,
        imageType: 1,
        displayOrder: slot + 1,
        isNew: false,
      );
      slot++;
    }

    emit(
      state.copyWith(
        slots: _normalizeSlots(workingSlots),
        isInitialized: true,
        clearError: true,
        clearSuccess: true,
      ),
    );
  }

  Future<void> addMarketplaceImagesSequentially({
    required int branchId,
    required List<File> files,
  }) async {
    if (branchId <= 0) {
      emit(
        state.copyWith(
          errorMessage: 'Invalid branch ID',
          clearSuccess: true,
          clearActivationSuccess: true,
        ),
      );
      return;
    }

    if (files.isEmpty) return;

    final marketplaceSlots = state.slots.sublist(
      firstMarketplaceSlotIndex,
      lastMarketplaceSlotIndex + 1,
    );
    final availableSlots = marketplaceSlots
        .where((item) => item == null)
        .length;

    if (files.length > availableSlots) {
      emit(
        state.copyWith(
          errorMessage: 'Maximum 3 marketplace images are allowed.',
          clearSuccess: true,
          clearActivationSuccess: true,
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        isUploading: true,
        clearError: true,
        clearSuccess: true,
        clearActivationSuccess: true,
      ),
    );

    final workingSlots = List<BranchUploadedImageItem?>.from(state.slots);

    for (final file in files) {
      final targetIndex = _firstEmptyMarketplaceIndex(workingSlots);
      if (targetIndex < 0) {
        emit(
          state.copyWith(
            isUploading: false,
            slots: _normalizeSlots(workingSlots),
            errorMessage: 'No empty marketplace slots available.',
            clearSuccess: true,
          ),
        );
        return;
      }

      final displayOrder = targetIndex + 1;
      const imageType = 1;

      final result = await uploadBranchImageUseCase(
        branchId: branchId,
        imageFile: file,
        imageType: imageType,
        displayOrder: displayOrder,
      );

      var failureMessage = '';
      result.fold((failure) => failureMessage = failure.message, (uploaded) {
        workingSlots[targetIndex] = _toItem(
          uploaded,
          isNew: true,
          fallbackDisplayOrder: displayOrder,
          fallbackImageType: imageType,
        );
      });

      if (failureMessage.isNotEmpty) {
        emit(
          state.copyWith(
            isUploading: false,
            slots: _normalizeSlots(workingSlots),
            errorMessage: failureMessage,
            clearSuccess: true,
          ),
        );
        return;
      }
    }

    emit(
      state.copyWith(
        isUploading: false,
        slots: _normalizeSlots(workingSlots),
        successMessage: 'Marketplace images uploaded as pending.',
        clearError: true,
      ),
    );
  }

  Future<void> addImagesSequentially({
    required int branchId,
    required List<File> files,
  }) async {
    if (branchId <= 0) {
      emit(
        state.copyWith(
          errorMessage: 'Invalid branch ID',
          clearSuccess: true,
          clearActivationSuccess: true,
        ),
      );
      return;
    }

    if (files.isEmpty) return;

    final availableSlots =
        BranchImagesState.maxImages - state.visibleImages.length;

    if (files.length > availableSlots) {
      emit(
        state.copyWith(
          errorMessage: 'Maximum 4 images are allowed.',
          clearSuccess: true,
          clearActivationSuccess: true,
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        isUploading: true,
        clearError: true,
        clearSuccess: true,
        clearActivationSuccess: true,
      ),
    );

    final workingSlots = List<BranchUploadedImageItem?>.from(state.slots);

    for (final file in files) {
      final targetIndex = _firstEmptyIndex(workingSlots);
      if (targetIndex < 0) {
        emit(
          state.copyWith(
            isUploading: false,
            slots: _normalizeSlots(workingSlots),
            errorMessage: 'No empty image slots available.',
            clearSuccess: true,
          ),
        );
        return;
      }

      final displayOrder = targetIndex + 1;
      final imageType = targetIndex == 0 ? 0 : 1;

      final result = await uploadBranchImageUseCase(
        branchId: branchId,
        imageFile: file,
        imageType: imageType,
        displayOrder: displayOrder,
      );

      var failureMessage = '';
      result.fold((failure) => failureMessage = failure.message, (uploaded) {
        workingSlots[targetIndex] = _toItem(
          uploaded,
          isNew: true,
          fallbackDisplayOrder: displayOrder,
          fallbackImageType: imageType,
        );

        debugPrint(
          '[BranchImagesCubit] Uploaded image id=${uploaded.id} order=$displayOrder type=$imageType',
        );
      });

      if (failureMessage.isNotEmpty) {
        emit(
          state.copyWith(
            isUploading: false,
            slots: _normalizeSlots(workingSlots),
            errorMessage: failureMessage,
            clearSuccess: true,
          ),
        );
        return;
      }
    }

    emit(
      state.copyWith(
        isUploading: false,
        slots: _normalizeSlots(workingSlots),
        successMessage: 'Images uploaded as pending.',
        clearError: true,
      ),
    );
  }

  Future<void> replaceOrAddAtIndex({
    required int branchId,
    required int index,
    required File file,
  }) async {
    if (branchId <= 0) {
      emit(
        state.copyWith(errorMessage: 'Invalid branch ID', clearSuccess: true),
      );
      return;
    }

    if (index < 0 || index >= BranchImagesState.maxImages) {
      emit(
        state.copyWith(errorMessage: 'Invalid image slot', clearSuccess: true),
      );
      return;
    }

    emit(
      state.copyWith(
        isUploading: true,
        clearError: true,
        clearSuccess: true,
        clearActivationSuccess: true,
      ),
    );

    final workingSlots = List<BranchUploadedImageItem?>.from(state.slots);
    final currentItem = workingSlots[index];

    final displayOrder = index + 1;
    final imageType = currentItem?.imageType ?? (index == 0 ? 0 : 1);

    final result = await uploadBranchImageUseCase(
      branchId: branchId,
      imageFile: file,
      imageType: imageType,
      displayOrder: displayOrder,
    );

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            isUploading: false,
            errorMessage: failure.message,
            clearSuccess: true,
          ),
        );
      },
      (uploaded) {
        workingSlots[index] = _toItem(
          uploaded,
          isNew: true,
          fallbackDisplayOrder: displayOrder,
          fallbackImageType: imageType,
        );

        emit(
          state.copyWith(
            isUploading: false,
            slots: _normalizeSlots(workingSlots),
            successMessage: 'Image updated in pending state.',
            clearError: true,
          ),
        );
      },
    );
  }

  void removeAtIndex(int index) {
    if (index < 0 || index >= BranchImagesState.maxImages) return;

    final workingSlots = List<BranchUploadedImageItem?>.from(state.slots);
    workingSlots[index] = null;

    emit(
      state.copyWith(
        slots: _normalizeSlots(workingSlots),
        clearError: true,
        successMessage: 'Image removed locally.',
        clearActivationSuccess: true,
      ),
    );
  }

  void moveImage(int fromIndex, int toIndex) {
    if (fromIndex == toIndex) return;
    if (fromIndex < 0 || toIndex < 0) return;
    if (fromIndex >= BranchImagesState.maxImages ||
        toIndex >= BranchImagesState.maxImages) {
      return;
    }

    final visible = [...state.visibleImages];
    if (fromIndex >= visible.length || toIndex >= visible.length) return;

    final item = visible.removeAt(fromIndex);
    visible.insert(toIndex, item);

    final normalizedVisible = <BranchUploadedImageItem>[];
    for (var i = 0; i < visible.length; i++) {
      normalizedVisible.add(visible[i].copyWith(displayOrder: i + 1));
    }

    final slots = List<BranchUploadedImageItem?>.filled(
      BranchImagesState.maxImages,
      null,
    );
    for (var i = 0; i < normalizedVisible.length && i < slots.length; i++) {
      slots[i] = normalizedVisible[i];
    }

    emit(
      state.copyWith(
        slots: slots,
        clearError: true,
        clearSuccess: true,
        clearActivationSuccess: true,
      ),
    );
  }

  Future<void> activateCurrentImages({required int branchId}) async {
    if (branchId <= 0) {
      emit(
        state.copyWith(errorMessage: 'Invalid branch ID', clearSuccess: true),
      );
      return;
    }

    final visible = state.visibleImages;
    if (visible.isEmpty) {
      emit(
        state.copyWith(
          errorMessage: 'Please upload at least one image before saving.',
          clearSuccess: true,
        ),
      );
      return;
    }

    if (visible.length > BranchImagesState.maxImages) {
      emit(
        state.copyWith(
          errorMessage: 'Maximum 4 images are allowed.',
          clearSuccess: true,
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        isSaving: true,
        clearError: true,
        clearSuccess: true,
        clearActivationSuccess: true,
      ),
    );

    final imageIds = visible.map((image) => image.id).toList();
    final result = await activateBranchImagesUseCase(
      branchId: branchId,
      imageIds: imageIds,
    );

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            isSaving: false,
            errorMessage: failure.message,
            clearSuccess: true,
          ),
        );
      },
      (_) {
        final updatedSlots = state.slots
            .map((item) => item?.copyWith(isNew: false))
            .toList();

        emit(
          state.copyWith(
            isSaving: false,
            slots: updatedSlots,
            successMessage: 'Images activated successfully.',
            activationSuccess: true,
            clearError: true,
          ),
        );
      },
    );
  }

  void clearTransientState() {
    if (state.errorMessage == null &&
        state.successMessage == null &&
        !state.activationSuccess) {
      return;
    }

    emit(
      state.copyWith(
        clearError: true,
        clearSuccess: true,
        clearActivationSuccess: true,
      ),
    );
  }

  BranchUploadedImageItem _toItem(
    UploadedBranchImageEntity entity, {
    required bool isNew,
    required int fallbackDisplayOrder,
    required int fallbackImageType,
  }) {
    return BranchUploadedImageItem(
      id: entity.id,
      url: entity.url,
      imageType: entity.imageType,
      displayOrder: entity.displayOrder <= 0
          ? fallbackDisplayOrder
          : entity.displayOrder,
      isNew: isNew,
    ).copyWith(
      imageType: entity.imageType < 0 ? fallbackImageType : entity.imageType,
    );
  }

  List<BranchUploadedImageItem?> _normalizeSlots(
    List<BranchUploadedImageItem?> source,
  ) {
    final normalizedSlots = List<BranchUploadedImageItem?>.filled(
      BranchImagesState.maxImages,
      null,
    );

    for (var index = 0; index < BranchImagesState.maxImages; index++) {
      final item = source[index];
      if (item == null) continue;
      final normalizedType = index == logoSlotIndex ? 0 : 1;
      normalizedSlots[index] = item.copyWith(
        displayOrder: index + 1,
        imageType: normalizedType,
      );
    }

    return normalizedSlots;
  }

  int _firstEmptyIndex(List<BranchUploadedImageItem?> source) {
    return source.indexWhere((item) => item == null);
  }

  int _firstEmptyMarketplaceIndex(List<BranchUploadedImageItem?> source) {
    for (
      var index = firstMarketplaceSlotIndex;
      index <= lastMarketplaceSlotIndex;
      index++
    ) {
      if (source[index] == null) return index;
    }
    return -1;
  }
}
