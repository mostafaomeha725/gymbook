part of 'branch_images_cubit.dart';

@immutable
class BranchUploadedImageItem {
  final int id;
  final String url;
  final int imageType;
  final int displayOrder;
  final bool isNew;

  const BranchUploadedImageItem({
    required this.id,
    required this.url,
    required this.imageType,
    required this.displayOrder,
    required this.isNew,
  });

  BranchUploadedImageItem copyWith({
    int? id,
    String? url,
    int? imageType,
    int? displayOrder,
    bool? isNew,
  }) {
    return BranchUploadedImageItem(
      id: id ?? this.id,
      url: url ?? this.url,
      imageType: imageType ?? this.imageType,
      displayOrder: displayOrder ?? this.displayOrder,
      isNew: isNew ?? this.isNew,
    );
  }
}

@immutable
class BranchImagesState {
  static const int maxImages = 4;

  final List<BranchUploadedImageItem?> slots;
  final bool isInitialized;
  final bool isUploading;
  final bool isSaving;
  final bool activationSuccess;
  final String? errorMessage;
  final String? successMessage;

  const BranchImagesState({
    required this.slots,
    this.isInitialized = false,
    this.isUploading = false,
    this.isSaving = false,
    this.activationSuccess = false,
    this.errorMessage,
    this.successMessage,
  });

  List<BranchUploadedImageItem> get visibleImages {
    return slots.whereType<BranchUploadedImageItem>().toList();
  }

  BranchImagesState copyWith({
    List<BranchUploadedImageItem?>? slots,
    bool? isInitialized,
    bool? isUploading,
    bool? isSaving,
    bool? activationSuccess,
    String? errorMessage,
    String? successMessage,
    bool clearError = false,
    bool clearSuccess = false,
    bool clearActivationSuccess = false,
  }) {
    return BranchImagesState(
      slots: slots ?? this.slots,
      isInitialized: isInitialized ?? this.isInitialized,
      isUploading: isUploading ?? this.isUploading,
      isSaving: isSaving ?? this.isSaving,
      activationSuccess: clearActivationSuccess
          ? false
          : (activationSuccess ?? this.activationSuccess),
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      successMessage: clearSuccess
          ? null
          : (successMessage ?? this.successMessage),
    );
  }
}
