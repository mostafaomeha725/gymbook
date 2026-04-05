import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gymbook/core/theme/styles.dart';
import 'package:gymbook/core/widgets/app_image.dart';
import 'package:gymbook/core/widgets/custom_text.dart';
import 'package:gymbook/core/widgets/switch_open_gym.dart';
import 'package:gymbook/features/admin_home/domain/entities/branch_entity.dart';
import 'package:gymbook/features/admin_home/presentation/widgets/tag_bage.dart';

class BranchHeaderSectionContent extends StatelessWidget {
  final BranchEntity branch;
  final String displayedCoverUrl;
  final String avatarUrl;
  final bool isActive;
  final ValueChanged<bool> onStatusChanged;
  final VoidCallback onBackTap;
  final List<String> galleryUrls;
  final int selectedIndex;
  final VoidCallback? onPreviousTap;
  final VoidCallback? onNextTap;
  final ValueChanged<int> onSelectImage;

  const BranchHeaderSectionContent({
    super.key,
    required this.branch,
    required this.displayedCoverUrl,
    required this.avatarUrl,
    required this.isActive,
    required this.onStatusChanged,
    required this.onBackTap,
    required this.galleryUrls,
    required this.selectedIndex,
    required this.onPreviousTap,
    required this.onNextTap,
    required this.onSelectImage,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            AppImage(
              imageUrl: displayedCoverUrl,
              height: 200.h,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            if (onPreviousTap != null)
              Positioned(
                left: 12.w,
                top: 0,
                bottom: 0,
                child: Center(
                  child: _HeaderArrowButton(
                    icon: Icons.arrow_back_ios_new,
                    onTap: onPreviousTap!,
                  ),
                ),
              ),
            if (onNextTap != null)
              Positioned(
                right: 12.w,
                top: 0,
                bottom: 0,
                child: Center(
                  child: _HeaderArrowButton(
                    icon: Icons.arrow_forward_ios,
                    onTap: onNextTap!,
                  ),
                ),
              ),
            Positioned(
              top: 28.h,
              left: 16.w,
              child: GestureDetector(
                onTap: onBackTap,
                child: const CircleAvatar(
                  backgroundColor: Colors.black45,
                  child: Icon(Icons.arrow_back, color: Colors.white),
                ),
              ),
            ),
            Positioned(
              bottom: -40.h,
              left: 24.w,
              child: CircleAvatar(
                radius: 43.r,
                backgroundColor: Colors.white,
                child: CircleAvatar(
                  radius: 40.r,
                  backgroundImage: NetworkImage(avatarUrl),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 44.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 22.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(
                      branch.name ?? 'Branch #${branch.id}',
                      style: font20w700.copyWith(
                        color: const Color(0xff2C3E50),
                      ),
                    ),
                    if (branch.governorate != null) ...[
                      SizedBox(height: 4.h),
                      AppText(
                        branch.governorate!.name,
                        style: font14w500.copyWith(color: Colors.grey[600]),
                      ),
                    ],
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Transform.scale(
                    scale: 0.8.h,
                    child: OpenGymSwitch(
                      value: isActive,
                      onChanged: onStatusChanged,
                    ),
                  ),
                  AppText(
                    isActive ? 'Active' : 'Inactive',
                    style: font14w500.copyWith(
                      color: isActive
                          ? const Color(0xFF16A34A)
                          : Colors.grey[500],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        SizedBox(height: 12.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 22.w),
          child: Row(
            children: [
              TagBadge(tag: branch.branchTypeName),
              SizedBox(width: 8.w),
              TagBadge(tag: branch.branchStatusName),
              if (branch.subscriptionsCount > 0) ...[
                SizedBox(width: 8.w),
                TagBadge(tag: '${branch.subscriptionsCount} subs'),
              ],
            ],
          ),
        ),
        if (galleryUrls.isNotEmpty) ...[
          SizedBox(height: 14.h),
          SizedBox(
            height: 82.h,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 22.w),
              itemCount: galleryUrls.length,
              separatorBuilder: (_, __) => SizedBox(width: 8.w),
              itemBuilder: (_, index) => GestureDetector(
                onTap: () => onSelectImage(index),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(
                      color: selectedIndex == index
                          ? const Color(0xff0EA5E9)
                          : Colors.transparent,
                      width: 2,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10.r),
                    child: AppImage(
                      imageUrl: galleryUrls[index],
                      width: 110.w,
                      height: 82.h,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class _HeaderArrowButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _HeaderArrowButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 34.w,
        height: 34.h,
        decoration: BoxDecoration(
          color: Colors.black45,
          borderRadius: BorderRadius.circular(999.r),
        ),
        child: Icon(icon, color: Colors.white, size: 18.sp),
      ),
    );
  }
}
