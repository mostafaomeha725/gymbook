import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gymbook/core/theme/styles.dart';
import 'package:gymbook/core/widgets/custom_text.dart';

class MembershipPlanPagination extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final int totalCount;
  final ValueChanged<int> onPageChanged;

  const MembershipPlanPagination({
    super.key,
    required this.currentPage,
    required this.totalPages,
    required this.totalCount,
    required this.onPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
      child: Container(
        color: Colors.red,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AppText(
              'Page $currentPage of $totalPages',
              style: font14w400.copyWith(color: const Color(0xff64748B)),
            ),
            Row(
              children: [
                PaginationNavButton(
                  icon: Icons.chevron_left_rounded,
                  enabled: currentPage > 1,
                  onTap: () => onPageChanged(currentPage - 1),
                ),
                SizedBox(width: 8.w),
                PaginationNavButton(
                  icon: Icons.chevron_right_rounded,
                  enabled: currentPage < totalPages,
                  onTap: () => onPageChanged(currentPage + 1),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class PaginationNavButton extends StatelessWidget {
  final IconData icon;
  final bool enabled;
  final VoidCallback onTap;

  const PaginationNavButton({
    super.key,
    required this.icon,
    required this.enabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: Container(
        width: 36.w,
        height: 36.w,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: enabled ? const Color(0xff0EA5E9) : const Color(0xffE2E8F0),
        ),
        child: Icon(
          icon,
          color: enabled ? Colors.white : const Color(0xffCBD5E1),
          size: 22.sp,
        ),
      ),
    );
  }
}
