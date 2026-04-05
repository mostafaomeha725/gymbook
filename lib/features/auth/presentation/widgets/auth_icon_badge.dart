import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AuthIconBadge extends StatelessWidget {
  const AuthIconBadge({
    super.key,
    this.icon = Icons.mail_outline,
    this.padding = 18,
    this.iconSize = 34,
  });

  final IconData icon;
  final double padding;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Container(
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF0EA5E9), Color(0xFF0284C7)],
          ),
        ),
        padding: EdgeInsets.all(padding.h),
        child: Icon(icon, color: Colors.white, size: iconSize.sp),
      ),
    );
  }
}
