import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gymbook/core/theme/styles.dart';
import 'package:gymbook/core/widgets/app_svg.dart';
import 'package:gymbook/core/widgets/custom_text.dart';
import 'package:gymbook/core/widgets/bouncing_widgets.dart';

class BouncingSocialButton extends StatelessWidget {
  const BouncingSocialButton({
    super.key,
    required this.text,
    this.onTap,
    this.assetName,
    this.icon,
    this.borderColor,
    this.textColor,
    this.textSize,
    this.color,
  });

  final String text;
  final VoidCallback? onTap;

  final String? assetName;
  final IconData? icon;

  final Color? borderColor;
  final Color? textColor;
  final double? textSize;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return BounceIt(
      onPressed: onTap,
      child: Container(
        height: 48.h,
        width: double.infinity,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: borderColor ?? const Color(0xFFDADADA)),
        ),
        child: Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              /// SVG
              if (assetName != null)
                AppSVG(
                  assetName: assetName!,
                  width: 20.w,
                  height: 20.h,
                  fit: BoxFit.contain,
                )
              /// Icon
              else if (icon != null)
                Icon(
                  icon,
                  size: 20.sp,
                  color: textColor ?? const Color(0xff0EA5E9),
                ),

              SizedBox(width: 12.w),

              AppText(
                text,
                maxLines: 1,
                alignment: AlignmentDirectional.center,
                style: font16w600.copyWith(
                  color: textColor ?? const Color(0xff0EA5E9),
                  fontSize: textSize ?? 16.sp,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
