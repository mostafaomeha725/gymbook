import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gymbook/core/theme/styles.dart';
import 'package:gymbook/core/widgets/custom_text.dart';

class EditOptionTile extends StatelessWidget {
  final EditOption option;

  const EditOptionTile({super.key, required this.option});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: option.onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 16.h),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              // ignore: deprecated_member_use
              color: Colors.black.withOpacity(0.05),
              blurRadius: 12.r,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),

              decoration: BoxDecoration(
                color: option.iconBg,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(option.icon, color: option.iconColor, size: 22.sp),
            ),
            SizedBox(width: 14.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(
                    option.title,
                    style: font16w700.copyWith(color: const Color(0xFF1E293B)),
                  ),
                  SizedBox(height: 3.h),
                  AppText(
                    option.subtitle,
                    style: font14w500.copyWith(color: Colors.grey[500]),
                    maxLines: 3,
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 14.sp, color: Colors.grey[400]),
          ],
        ),
      ),
    );
  }
}

class EditOption {
  final IconData icon;
  final Color iconColor;
  final Color iconBg;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const EditOption({
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });
}
