import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gymbook/core/theme/styles.dart';
import 'package:gymbook/core/widgets/custom_text.dart';

class RoleSelectionWidget extends StatelessWidget {
  final int selectedRole;
  final ValueChanged<int> onChanged;

  const RoleSelectionWidget({
    super.key,
    required this.selectedRole,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildRoleCard(
            title: 'Admin',
            icon: Icons.groups,
            iconColor: const Color(0xff0EA5E9),
            value: 2,
          ),
          SizedBox(width: 8.w),
          _buildRoleCard(
            title: 'Employee',
            icon: Icons.assignment_ind,
            iconColor: const Color(0xff0EA5E9),
            value: 3,
          ),
          SizedBox(width: 8.w),
          _buildRoleCard(
            title: 'Customer',
            icon: Icons.person,
            iconColor: const Color(0xff0EA5E9),
            value: 4,
          ),
        ],
      ),
    );
  }

  Widget _buildRoleCard({
    required String title,
    required IconData icon,
    required Color iconColor,
    required int value,
  }) {
    final isSelected = selectedRole == value;
    return Expanded(
      child: GestureDetector(
        onTap: () => onChanged(value),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: EdgeInsets.all(8.w),
          decoration: BoxDecoration(
            color: isSelected
                // ignore: deprecated_member_use
                ? const Color(0xff0EA5E9).withOpacity(0.05)
                : Colors.white,
            border: Border.all(
              color: isSelected
                  ? const Color(0xff0EA5E9)
                  : Colors.grey.shade200,
              width: isSelected ? 1.5 : 1,
            ),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              if (isSelected)
                Positioned(
                  top: -8.h,
                  right: 0,
                  child: Icon(
                    Icons.check_circle,
                    color: const Color(0xff0EA5E9),
                    size: 18.sp,
                  ),
                ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(icon, size: 36.sp, color: iconColor),
                  SizedBox(height: 12.h),
                  AppText(
                    title,
                    style: font14w500.copyWith(
                      color: isSelected
                          ? const Color(0xff0EA5E9)
                          : const Color(0xff1E293B),
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                    ),
                    alignment: AlignmentDirectional.center,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
