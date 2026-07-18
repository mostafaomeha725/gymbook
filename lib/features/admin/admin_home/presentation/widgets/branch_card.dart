import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gymbook/core/theme/styles.dart';
import 'package:gymbook/core/widgets/app_image.dart';
import 'package:gymbook/core/widgets/custom_text.dart';
import 'package:gymbook/features/admin/admin_home/presentation/widgets/tag_bage.dart';

class BranchCard extends StatelessWidget {
  final String? imageUrl;
  final String branchName;
  final String location;
  final List<String> tags;
  final int subscriptions;
  final VoidCallback? onTap;

  const BranchCard({
    super.key,
    required this.imageUrl,
    required this.branchName,
    required this.location,
    required this.tags,
    required this.subscriptions,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 12.r,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image with full width
              SizedBox(
                width: double.infinity,
                height: 130.h,
                child: (imageUrl != null && imageUrl!.trim().isNotEmpty)
                    ? Stack(
                        fit: StackFit.expand,
                        children: [
                          AppImage(imageUrl: imageUrl!, fit: BoxFit.cover),
                        ],
                      )
                    : Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [Color(0xff0EA5E9), Color(0xff0284C7)],
                          ),
                        ),
                        child: Center(
                          child: Container(
                            padding: EdgeInsets.all(12.w),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.2),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.storefront_outlined,
                              size: 32.sp,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
              ),
              Padding(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: AppText(
                            branchName,
                            style: font18w700.copyWith(
                              color: const Color(0xFF333333),
                            ),
                            maxLines: 1,
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 16.sp,
                          color: Colors.grey[400],
                        ),
                      ],
                    ),
                    SizedBox(height: 8.h),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          size: 16.sp,
                          color: Colors.grey[600],
                        ),
                        SizedBox(width: 6.w),
                        Expanded(
                          child: AppText(
                            location,
                            style: font14w500.copyWith(color: Colors.grey[600]),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Tags
                        Flexible(
                          child: Row(
                            children: List.generate(
                              tags.length,
                              (index) => Padding(
                                padding: EdgeInsets.only(right: 6.w),
                                child: TagBadge(tag: tags[index]),
                              ),
                            ),
                          ),
                        ),

                        // Subscriptions count
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
