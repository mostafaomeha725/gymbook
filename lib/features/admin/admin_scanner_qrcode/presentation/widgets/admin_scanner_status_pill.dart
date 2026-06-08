import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gymbook/core/theme/styles.dart';
import 'package:gymbook/core/widgets/custom_text.dart';

class AdminScannerStatusPill extends StatelessWidget {
  final bool isSubmitting;
  final bool hasSelectedBranch;

  const AdminScannerStatusPill({
    super.key,
    required this.isSubmitting,
    required this.hasSelectedBranch,
  });

  @override
  Widget build(BuildContext context) {
    final bool isReady = !isSubmitting && hasSelectedBranch;
    final Color bgColor = isSubmitting
        ? const Color(0xFFFEF3C7) // Amber light
        : isReady
        ? const Color(0xFFF0FDF4) // Green light
        : const Color(0xFFF1F5F9); // Slate light
    final Color borderColor = isSubmitting
        ? const Color(0xFFFDE68A)
        : isReady
        ? const Color(0xFFBBF7D0)
        : const Color(0xFFE2E8F0);
    final Color textColor = isSubmitting
        ? const Color(0xFFD97706)
        : isReady
        ? const Color(0xFF16A34A)
        : const Color(0xFF64748B);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(30.r),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isSubmitting) ...[
            SizedBox(
              width: 16.w,
              height: 16.w,
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                valueColor: AlwaysStoppedAnimation<Color>(textColor),
              ),
            ),
            SizedBox(width: 12.w),
            AppText(
              'Processing...',
              style: font14w700.copyWith(color: textColor),
            ),
          ] else ...[
            Icon(
              isReady ? Icons.qr_code_scanner : Icons.info_outline,
              color: textColor,
              size: 20.w,
            ),
            SizedBox(width: 8.w),
            AppText(
              isReady ? 'Ready to scan' : 'Select a branch first',
              style: font14w700.copyWith(color: textColor),
            ),
          ],
        ],
      ),
    );
  }
}
