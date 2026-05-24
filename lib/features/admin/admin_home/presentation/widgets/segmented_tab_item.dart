import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gymbook/core/widgets/custom_text.dart';
import 'package:gymbook/core/theme/styles.dart';

class SegmentedTabItem extends StatelessWidget {
  const SegmentedTabItem({
    super.key,
    required this.text,
    required this.isSelected,
    required this.onTap,
    this.selectedColor,
    this.unSelectedColor,
  });

  final String text;
  final bool isSelected;
  final VoidCallback onTap;
  final Color? selectedColor;
  final Color? unSelectedColor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: isSelected
              ? (selectedColor ?? const Color(0xFF0EA5E9))
              : (unSelectedColor ?? Colors.grey.shade200),
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Center(
          child: AppText(
            text,
            style: font16w600.copyWith(
              color: isSelected ? Colors.white : const Color(0xff4B5563),
            ),
          ),
        ),
      ),
    );
  }
}
