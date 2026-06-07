import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gymbook/core/theme/styles.dart';
import 'package:gymbook/core/widgets/custom_text.dart';
import 'package:gymbook/core/widgets/switch_open_gym.dart';

class EmployeeCardActions extends StatelessWidget {
  final VoidCallback? onEdit;
  final bool hasStatus;
  final bool isActive;

  const EmployeeCardActions({
    super.key,
    this.onEdit,
    this.hasStatus = false,
    this.isActive = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Top: Option Menu
        PopupMenuButton<String>(
          padding: EdgeInsets.zero,
          icon: Icon(Icons.more_vert, color: Colors.grey, size: 20.sp),
          onSelected: (value) {
            if (value == 'edit' && onEdit != null) {
              onEdit!();
            }
          },
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.r),
          ),
          color: Colors.white,
          elevation: 4,
          itemBuilder: (context) => [
            PopupMenuItem(
              value: 'edit',
              child: Row(
                children: [
                  Icon(Icons.edit_outlined, size: 16.sp, color: Colors.grey),
                  SizedBox(width: 8.w),
                  AppText(
                    'Edit',
                    style: font12w400.copyWith(color: Colors.black87),
                  ),
                ],
              ),
            ),
          ],
        ),

        // Bottom: Switch (if applicable)
        if (hasStatus) ...[
          SizedBox(height: 12.h),
          Row(
            children: [
              AppText(
                isActive ? 'Active' : 'Inactive',
                style: font12w500.copyWith(
                  color: isActive
                      ? const Color(0xFF10B981)
                      : const Color(0xFFEF4444),
                ),
              ),
              SizedBox(width: 8.w),
              Transform.scale(
                scale: 0.9,
                child: OpenGymSwitch(
                  value: isActive,
                  onChanged: (_) {},
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}
