import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gymbook/core/theme/styles.dart';
import 'package:gymbook/core/widgets/custom_text.dart';

class StatusBadge extends StatelessWidget {
  final String text;
  final Color color;
  final Color bgColor;

  const StatusBadge({
    super.key,
    required this.text,
    required this.color,
    required this.bgColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: AppText(text, style: font12w500.copyWith(color: color)),
    );
  }
}
