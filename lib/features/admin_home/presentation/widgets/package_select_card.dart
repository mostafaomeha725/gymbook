import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gymbook/features/admin_home/presentation/widgets/content_package_select_card.dart';


class PackageSelectCard extends StatelessWidget {
  const PackageSelectCard({
    super.key,
    required this.title,
    required this.duration,
    required this.price,
    required this.freezes,
    required this.icon,
    required this.isActive,
    required this.onTap,
  });

  final String title;
  final String duration;
  final String price;
  final String freezes;
  final IconData icon;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    const mainColor = Color(0xFF0EA5E9);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22.r),
          border: Border.all(
            color: isActive ? mainColor : Colors.grey.shade300,
            width: 1.5.w,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(13),
              blurRadius: 14.r,
              offset: const Offset(0, 6),
            ),
          ],
        ),

        child: ContentPackageSelectCard(
          title: title,
          duration: duration,
          price: price,
          freezes: freezes,
          icon: icon,
          isActive: isActive,
        ),
      ),
    );
  }
}
