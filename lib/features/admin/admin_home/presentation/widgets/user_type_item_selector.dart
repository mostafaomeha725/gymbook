import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gymbook/core/widgets/custom_text.dart';
import 'package:gymbook/core/theme/styles.dart';

class UserTypeItemSelector extends StatelessWidget {
  const UserTypeItemSelector({
    super.key,
    required this.index,
    required this.selectedIndex,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });

  final int index;
  final int selectedIndex;
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isActive = selectedIndex == index;

    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(
              color: isActive ? const Color(0xFF0EA5E9) : Colors.grey.shade300,
              width: 1.5.w,
            ),
            color: isActive
                ? const Color(0xFF0EA5E9).withAlpha(20)
                : Colors.white,
          ),
          child: Column(
            children: [
              Icon(
                icon,
                color: isActive ? const Color(0xFF0EA5E9) : Colors.grey,
                size: 28.sp,
              ),

              SizedBox(height: 8.h),

              AppText(
                title,
                style: font14w700.copyWith(
                  color: isActive
                      ? const Color(0xFF0EA5E9)
                      : const Color(0xff334155),
                ),
              ),

              AppText(subtitle, style: font12w400.copyWith(color: Colors.grey)),
            ],
          ),
        ),
      ),
    );
  }
}
