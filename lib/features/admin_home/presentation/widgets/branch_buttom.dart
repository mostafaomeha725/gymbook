import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gymbook/core/theme/light_colors.dart';
import 'package:gymbook/core/widgets/bouncing_social_button.dart';

class BranchButtom extends StatelessWidget {
  const BranchButtom({
    super.key,
    this.icon,
    required this.text,
    required this.onTap,
    this.gradient,
    this.iconGradient,
  });

  final IconData? icon;
  final String text;
  final VoidCallback onTap;
  final Gradient? gradient;
  final Gradient? iconGradient;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 22.w),
      child: BouncingSocialButton(
        height: 64.h,
        text: text,

        gradient: gradient ?? AppLightColors.buttonGradient,

        leading: icon == null
            ? null
            : Container(
                height: 44.h,
                width: 44.w,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.r),

                  gradient:
                      iconGradient ??
                      const LinearGradient(
                        colors: [Color(0xFF38BDF8), Color(0xFF0EA5E9)],
                      ),
                ),
                child: Icon(icon, color: Colors.white, size: 16.sp),
              ),

        onTap: onTap,
      ),
    );
  }
}
