// --- تصميم زر السهم المستدير ---
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ArrowButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const ArrowButton({super.key, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: CircleAvatar(
        backgroundColor: Colors.black45,
        radius: 22.r,
        child: Icon(icon, color: Colors.white, size: 18.sp),
      ),
    );
  }
}
