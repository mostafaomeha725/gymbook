import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gymbook/core/theme/light_colors.dart';
import 'package:gymbook/features/auth/presentation/screens/widgets/bouncing_social_button.dart';

class BranchButtom extends StatelessWidget {
  const BranchButtom({
    super.key,
    this.icon,
    required this.text,
    required this.onTap,
  });
  final IconData? icon;
  final String text;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 22.w),
      child: BouncingSocialButton(
        height: 64.h,
        text: text,
        gradient: AppLightColors.buttonGradient,
        leading: Container(
          height: 44.h,
          width: 44.w,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.r),
            gradient: const LinearGradient(
              colors: [Color(0xFF38BDF8), Color(0xFF0EA5E9)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Icon(icon, color: Colors.white, size: 16),
        ),
        onTap: onTap,
      ),
    );
  }
}
