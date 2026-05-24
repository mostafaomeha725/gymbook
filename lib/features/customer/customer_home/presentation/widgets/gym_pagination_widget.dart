import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gymbook/core/theme/styles.dart';
import 'package:gymbook/core/widgets/custom_text.dart';

class GymPaginationWidget extends StatelessWidget {
  final int totalPages;
  final int currentPage;
  final Function(int) onPageChanged;

  const GymPaginationWidget({
    super.key,
    required this.totalPages,
    required this.currentPage,
    required this.onPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(totalPages, (index) {
          int pageNum = index + 1;
          bool isActive = pageNum == currentPage;

          return GestureDetector(
            onTap: () => onPageChanged(pageNum),
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 5.w),
              width: 45.w,
              height: 45.w,
              decoration: BoxDecoration(
                color: isActive ? const Color(0xFF0EA5E9) : Colors.white,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(
                  color: isActive
                      ? Colors.transparent
                      : const Color(0xFFE2E8F0),
                  width: 1.5.w,
                ),
                boxShadow: isActive
                    ? [
                        BoxShadow(
                          color: const Color(0xFF0EA5E9).withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ]
                    : [],
              ),
              child: AppText(
                '$pageNum',
                style: font16w500.copyWith(
                  color: isActive ? Colors.white : const Color(0xFF1E293B),
                  fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                ),
                alignment: AlignmentDirectional.center,
              ),
            ),
          );
        }),
      ),
    );
  }
}
