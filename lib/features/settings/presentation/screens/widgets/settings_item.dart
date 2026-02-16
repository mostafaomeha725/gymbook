import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gymbook/core/theme/styles.dart';
import 'package:gymbook/core/widgets/custom_text.dart';

class SettingsItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final bool showArrow;
  final Widget? trailing;
  final Color? titleColor;
  final VoidCallback? onTap;

  const SettingsItem({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.showArrow = false,
    this.trailing,
    this.titleColor,
    this.onTap,
  });

  Widget? _buildTrailing() {
    if (trailing != null) return trailing;
    if (showArrow) return const Icon(Icons.chevron_right);
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final trailingWidget = _buildTrailing();

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12.r),
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Icon(
                  icon,
                  color: titleColor == Colors.red ? Colors.red : Colors.blue,
                  size: 20.sp,
                ),
              ),

              16.horizontalSpace,

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(
                      title,
                      style: font14w700.copyWith(
                        color: titleColor ?? Colors.black,
                      ),
                    ),
                    if (subtitle != null) ...[
                      4.verticalSpace,
                      AppText(
                        subtitle!,
                        style: font12w400.copyWith(color: Colors.grey),
                      ),
                    ],
                  ],
                ),
              ),

              if (trailingWidget != null) trailingWidget,
            ],
          ),
        ),
      ),
    );
  }
}
