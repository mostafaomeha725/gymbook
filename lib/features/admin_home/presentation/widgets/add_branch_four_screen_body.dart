import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gymbook/features/admin_home/presentation/cubits/branch_images_cubit/branch_images_cubit.dart';
import 'package:gymbook/features/admin_home/presentation/cubits/branch_setup_cubit/branch_setup_cubit.dart';
import 'package:gymbook/features/admin_home/presentation/widgets/add_branch_four_screen_actions.dart';
import 'package:gymbook/features/admin_home/presentation/widgets/add_branch_four_screen_content.dart';
import 'package:image_picker/image_picker.dart';

class AddBranchFourScreenBody extends StatefulWidget {
  final int branchId;
  final bool isEditMode;
  final int? imageId;
  final String? logoUrl;

  const AddBranchFourScreenBody({
    super.key,
    this.branchId = 0,
    this.isEditMode = false,
    this.imageId,
    this.logoUrl,
  });

  @override
  State<AddBranchFourScreenBody> createState() =>
      _AddBranchFourScreenBodyState();
}

class _AddBranchFourScreenBodyState extends State<AddBranchFourScreenBody> {
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickLogo() async {
    await AddBranchFourScreenActions.pickLogo(
      context: context,
      picker: _picker,
      branchId: widget.branchId,
    );
  }

  Future<void> _pickMultipleMarketplaceImages() async {
    await AddBranchFourScreenActions.pickMultipleMarketplaceImages(
      context: context,
      picker: _picker,
      branchId: widget.branchId,
    );
  }

  Future<void> _pickForSlot({required int index}) async {
    await AddBranchFourScreenActions.pickForSlot(
      context: context,
      picker: _picker,
      branchId: widget.branchId,
      index: index,
    );
  }

  void _handleSetupStateChanges(BranchSetupState setupState) {
    AddBranchFourScreenActions.handleSetupStateChanges(
      context: context,
      setupState: setupState,
      isEditMode: widget.isEditMode,
      fallbackLogoImageId: widget.imageId,
      fallbackLogoUrl: widget.logoUrl,
    );
  }

  void _handleImagesStateChanges(BranchImagesState imagesState) {
    AddBranchFourScreenActions.handleImagesStateChanges(
      context: context,
      imagesState: imagesState,
      isEditMode: widget.isEditMode,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<BranchSetupCubit, BranchSetupState>(
          listenWhen: (previous, current) =>
              previous.errorMessage != current.errorMessage ||
              previous.details != current.details,
          listener: (context, setupState) =>
              _handleSetupStateChanges(setupState),
        ),
        BlocListener<BranchImagesCubit, BranchImagesState>(
          listenWhen: (previous, current) =>
              previous.isUploading != current.isUploading ||
              previous.isSaving != current.isSaving ||
              previous.errorMessage != current.errorMessage ||
              previous.successMessage != current.successMessage ||
              previous.activationSuccess != current.activationSuccess,
          listener: (context, imagesState) =>
              _handleImagesStateChanges(imagesState),
        ),
      ],
      child: BlocBuilder<BranchSetupCubit, BranchSetupState>(
        builder: (context, setupState) {
          return BlocBuilder<BranchImagesCubit, BranchImagesState>(
            builder: (context, imagesState) {
              if (widget.isEditMode &&
                  setupState.isLoading &&
                  !setupState.hasData &&
                  !imagesState.isInitialized) {
                return const Center(child: CircularProgressIndicator());
              }

              final logoItem =
                  imagesState.slots[BranchImagesCubit.logoSlotIndex];
              final marketplaceSlots = [
                imagesState.slots[1],
                imagesState.slots[2],
                imagesState.slots[3],
              ];
              final marketplaceCount = marketplaceSlots
                  .whereType<BranchUploadedImageItem>()
                  .length;
              final isBusy = imagesState.isUploading || imagesState.isSaving;

              return AddBranchFourScreenContent(
                isEditMode: widget.isEditMode,
                logoItem: logoItem,
                marketplaceSlots: marketplaceSlots,
                marketplaceCount: marketplaceCount,
                isBusy: isBusy,
                isSaving: imagesState.isSaving,
                onPickLogo: _pickLogo,
                onPickMarketplaceImages: _pickMultipleMarketplaceImages,
                onPickSlot: (index) => _pickForSlot(index: index),
                onRemoveSlot: (index) =>
                    context.read<BranchImagesCubit>().removeAtIndex(index),
                onSave: () {
                  context.read<BranchImagesCubit>().activateCurrentImages(
                    branchId: widget.branchId,
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
