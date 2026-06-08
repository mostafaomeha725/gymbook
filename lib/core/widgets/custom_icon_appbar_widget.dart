import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gymbook/core/theme/styles.dart';
import 'package:gymbook/core/widgets/custom_text.dart';

class CustomIconAppbarWidget extends StatelessWidget {
  const CustomIconAppbarWidget({
    super.key,
    required this.text,
    this.subtitle,
    this.customIcon,
  });

  final String text;
  final String? subtitle;
  final Widget? customIcon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF0EA5E9), Color(0xFF0284C7)],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(28.r),
          bottomRight: Radius.circular(28.r),
        ),
      ),
      padding: EdgeInsets.only(
        top: 50.h,
        bottom: 24.h,
        left: 20.w,
        right: 20.w,
      ),
      child: Row(
        children: [
          if (customIcon != null) ...[customIcon!, SizedBox(width: 16.w)],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                AppText(text, style: font20w700.copyWith(color: Colors.white)),
                if (subtitle != null) ...[
                  SizedBox(height: 4.h),
                  AppText(
                    subtitle!,
                    style: font12w400.copyWith(
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
