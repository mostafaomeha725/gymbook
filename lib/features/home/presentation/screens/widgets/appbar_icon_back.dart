import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppbarIconBack extends StatelessWidget {
  const AppbarIconBack({
    super.key,
    this.icon,
    this.color,
    this.isgalary = false,
    this.onTap,
  });

  final IconData? icon;
  final Color? color;
  final bool isgalary;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.r),
        child: color == null
            ? Stack(
                alignment: Alignment.center,
                children: [
                  BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                    child: Container(
                      width: 40.w,
                      height: 40.h,
                      color: const Color(0xffb5aca0).withOpacity(0.1),
                    ),
                  ),
                  Icon(
                    icon,
                    color: isgalary ? Colors.white : Colors.black,
                    size: 22.sp,
                  ),
                ],
              )
            : Container(
                width: 40.w,
                height: 40.h,
                color: color,
                alignment: Alignment.center,
                child: Icon(
                  icon,
                  color: isgalary ? Colors.white : Colors.black,
                  size: 22.sp,
                ),
              ),
      ),
    );
  }
}
