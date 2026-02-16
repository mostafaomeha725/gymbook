import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gymbook/core/theme/styles.dart';
import 'package:gymbook/core/widgets/custom_text.dart';
import 'package:gymbook/core/widgets/switch_open_gym.dart';

class PackageCard extends StatelessWidget {
  const PackageCard({
    super.key,
    required this.title,
    required this.months,
    required this.freezes,
    required this.price,
    required this.isActive,
    required this.sideColor,
    this.onToggle,
    this.onEdit,
    this.onDelete,
  });

  final String title;
  final int months;
  final int freezes;
  final String price;
  final bool isActive;
  final Color sideColor;
  final ValueChanged<bool>? onToggle;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 22.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18.r),
        boxShadow: [
          BoxShadow(
            // ignore: deprecated_member_use
            color: Colors.black.withOpacity(.08),
            blurRadius: 14.r,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18.r),
        child: IntrinsicHeight(
          child: Row(
            children: [
              Container(
                width: 4.w,
                decoration: BoxDecoration(color: sideColor),
              ),

              SizedBox(width: 12.w),

              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 14.h,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 48.h,
                            width: 48.w,
                            decoration: BoxDecoration(
                              color: isActive
                                  ? const Color(0x200EA5E9)
                                  // أزرق فاتح
                                  : const Color(0xffF3F4F6), // رمادي فاتح
                              borderRadius: BorderRadius.circular(14.r),
                            ),
                            child: Icon(
                              Icons.inventory_2_outlined,
                              size: 26.sp,
                              color: isActive
                                  ? const Color(0xFF0EA5E9) // أزرق
                                  : const Color(0xff9CA3AF), // رمادي
                            ),
                          ),

                          SizedBox(width: 12.w),

                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AppText(title, style: font18w700, maxLines: 2),
                                SizedBox(height: 4.h),
                                AppText(
                                  "$months Months  •  $freezes Freezes",
                                  style: font14w400.copyWith(
                                    color: const Color(0xff4A5565),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          PopupMenuButton(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            itemBuilder: (context) => [
                              PopupMenuItem(
                                onTap: onEdit,
                                child: Row(
                                  children: [
                                    Icon(Icons.edit, size: 18.sp),
                                    SizedBox(width: 8.w),
                                    const AppText("Edit"),
                                  ],
                                ),
                              ),
                              PopupMenuItem(
                                onTap: onDelete,
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.delete,
                                      size: 18.sp,
                                      color: Colors.red,
                                    ),
                                    SizedBox(width: 8.w),
                                    const AppText(
                                      "Delete",
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                            child: const Icon(Icons.more_vert),
                          ),
                        ],
                      ),

                      SizedBox(height: 12.h),

                      Padding(
                        padding: EdgeInsets.only(left: 60.w),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                AppText(
                                  price,
                                  style: font24w700.copyWith(
                                    color: const Color(0xFF0EA5E9),
                                  ),
                                ),
                                SizedBox(width: 6.w),
                                AppText(
                                  "EGP",
                                  style: font14w400.copyWith(
                                    color: const Color(0xff6A7282),
                                  ),
                                ),
                              ],
                            ),

                            Row(
                              children: [
                                AppText(
                                  isActive ? "Active" : "Inactive",
                                  style: font14w500.copyWith(
                                    color: Colors.grey,
                                  ),
                                ),
                                SizedBox(width: 6.w),
                                Transform.scale(
                                  scale: 0.9.h,
                                  child: OpenGymSwitch(
                                    value: isActive,
                                    onChanged: onToggle!,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
