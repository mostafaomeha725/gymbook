import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:gymbook/core/di/services_locator.dart';
import 'package:gymbook/core/theme/styles.dart';
import 'package:gymbook/core/utils/easy_loading.dart';
import 'package:gymbook/core/widgets/app_image.dart';
import 'package:gymbook/core/widgets/custom_text.dart';
import 'package:gymbook/core/widgets/switch_open_gym.dart';
import 'package:gymbook/features/admin_home/data/models/branch_list_model.dart';
import 'package:gymbook/features/admin_home/data/repositories/admin_branch_repository.dart';
import 'package:gymbook/features/admin_home/presentation/widgets/tag_bage.dart';

class BranchHeaderSection extends StatefulWidget {
  final BranchItem branch;

  const BranchHeaderSection({super.key, required this.branch});

  @override
  State<BranchHeaderSection> createState() => _BranchHeaderSectionState();
}

class _BranchHeaderSectionState extends State<BranchHeaderSection> {
  /// true = Active (status 1), false = Inactive (status 2)
  late bool isActive;

  static const String _placeholderImage =
      'https://images.unsplash.com/photo-1506744038136-46273834b3fb';

  @override
  void initState() {
    super.initState();
    isActive = widget.branch.branchStatus == 1;
  }

  Future<void> _updateStatus(bool value) async {
    setState(() => isActive = value);

    showLoading();
    final result = await sl<AdminBranchRepository>().updateBranchStatus(
      branchId: widget.branch.id,
      branchStatus: value ? 1 : 0,
    );
    hideLoading();

    result.fold((failure) {
      setState(() => isActive = !value); // revert
      showError(failure);
    }, (_) {});
  }

  @override
  Widget build(BuildContext context) {
    final branch = widget.branch;
    return Column(
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            AppImage(
              imageUrl: branch.logo ?? _placeholderImage,
              height: 200.h,
              width: double.infinity,
              fit: BoxFit.cover,
            ),

            Positioned(
              top: 28.h,
              left: 16.w,
              child: GestureDetector(
                onTap: () => GoRouter.of(context).pop(),
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
                  backgroundImage: NetworkImage(
                    branch.logo ??
                        'https://randomuser.me/api/portraits/men/32.jpg',
                  ),
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
                      onChanged: _updateStatus,
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

        // if (branch.address != null && branch.address!.isNotEmpty) ...[
        //   SizedBox(height: 8.h),
        //   Padding(
        //     padding: EdgeInsets.symmetric(horizontal: 22.w),
        //     child: Row(
        //       children: [
        //         Icon(
        //           Icons.location_on_outlined,
        //           size: 14.sp,
        //           color: Colors.grey[500],
        //         ),
        //         SizedBox(width: 4.w),
        //         Expanded(
        //           child: AppText(
        //             branch.address!,
        //             style: font14w500.copyWith(color: Colors.grey[500]),
        //             maxLines: 2,
        //             overflow: TextOverflow.ellipsis,
        //           ),
        //         ),
        //       ],
        //     ),
        //   ),
      ],
    );
  }
}
