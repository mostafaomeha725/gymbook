import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gymbook/core/theme/styles.dart';
import 'package:gymbook/core/widgets/custom_button.dart';
import 'package:gymbook/core/widgets/custom_text.dart';
import 'package:gymbook/features/admin_home/presentation/cubits/branch_images_cubit/branch_images_cubit.dart';
import 'package:gymbook/features/admin_home/presentation/widgets/add_branch_four_image_slot_card.dart';
import 'package:gymbook/features/admin_home/presentation/widgets/add_branch_four_section_title.dart';
import 'package:gymbook/features/admin_home/presentation/widgets/gym_photos_uploader.dart';
import 'package:gymbook/features/auth/presentation/widgets/appbar_auth_card.dart';

class AddBranchFourScreenContent extends StatelessWidget {
  final bool isEditMode;
  final BranchUploadedImageItem? logoItem;
  final List<BranchUploadedImageItem?> marketplaceSlots;
  final int marketplaceCount;
  final bool isBusy;
  final bool isSaving;
  final VoidCallback onPickLogo;
  final VoidCallback onPickMarketplaceImages;
  final ValueChanged<int> onPickSlot;
  final ValueChanged<int> onRemoveSlot;
  final VoidCallback onSave;

  const AddBranchFourScreenContent({
    super.key,
    required this.isEditMode,
    required this.logoItem,
    required this.marketplaceSlots,
    required this.marketplaceCount,
    required this.isBusy,
    required this.isSaving,
    required this.onPickLogo,
    required this.onPickMarketplaceImages,
    required this.onPickSlot,
    required this.onRemoveSlot,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          children: [
            AppbarAuthCard(
              title: isEditMode ? 'Edit Branch' : 'Add Branch',
              subtitle: 'Step 4 of 4: Add Photos',
              currentStep: 4,
              totalSteps: 4,
            ),
            SizedBox(height: 16.h),
            AppText(
              'Upload 1 logo and up to 3 marketplace images. New uploads stay pending until Save.',
              style: font12w400.copyWith(color: const Color(0xff6B7280)),
              alignment: AlignmentDirectional.center,
            ),
            SizedBox(height: 16.h),
            const AddBranchFourSectionTitle(title: 'Branch Logo'),
            SizedBox(height: 10.h),
            GymPhotosUploader(
              onTap: isBusy ? () {} : onPickLogo,
              maxPhotos: 1,
              currentPhotosCount: logoItem == null ? 0 : 1,
            ),
            SizedBox(height: 12.h),
            AddBranchFourImageSlotCard(
              item: logoItem,
              onTap: () => onPickSlot(BranchImagesCubit.logoSlotIndex),
              onRemove: () => onRemoveSlot(BranchImagesCubit.logoSlotIndex),
              emptyLabel: 'Tap to add logo',
            ),
            SizedBox(height: 20.h),
            const AddBranchFourSectionTitle(title: 'Marketplace Images'),
            SizedBox(height: 10.h),
            GymPhotosUploader(
              onTap: isBusy ? () {} : onPickMarketplaceImages,
              maxPhotos: 3,
              currentPhotosCount: marketplaceCount,
            ),
            SizedBox(height: 16.h),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: marketplaceSlots.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10.w,
                mainAxisSpacing: 10.h,
                childAspectRatio: 0.82,
              ),
              itemBuilder: (context, index) {
                final slotIndex = index + 1;
                final item = marketplaceSlots[index];
                return AddBranchFourImageSlotCard(
                  item: item,
                  onTap: () => onPickSlot(slotIndex),
                  onRemove: () => onRemoveSlot(slotIndex),
                  emptyLabel: 'Tap to add image',
                );
              },
            ),
            SizedBox(height: 10.h),
            AppText(
              'Logo: ${logoItem == null ? 0 : 1}/1, Marketplace: $marketplaceCount/3',
              style: font12w400.copyWith(color: const Color(0xff9CA3AF)),
            ),
            SizedBox(height: 20.h),
            AppButton(
              text: isSaving ? 'Saving...' : 'Save & Activate Images',
              onPressed: isBusy ? null : onSave,
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
