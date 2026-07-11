import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:gymbook/features/admin/admin_scanner_qrcode/presentation/widgets/admin_scanner_status_pill.dart';

class AdminQrScannerCameraSection extends StatelessWidget {
  const AdminQrScannerCameraSection({
    super.key,
    required this.isSubmitting,
    required this.hasSelectedBranch,
    required this.onDetect,
  });

  final bool isSubmitting;
  final bool hasSelectedBranch;
  final void Function(BarcodeCapture) onDetect;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 20.r,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          children: [
            Expanded(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16.r),
                    child: MobileScanner(fit: BoxFit.cover, onDetect: onDetect),
                  ),
                ],
              ),
            ),
            SizedBox(height: 24.h),
            AdminScannerStatusPill(
              isSubmitting: isSubmitting,
              hasSelectedBranch: hasSelectedBranch,
            ),
          ],
        ),
      ),
    );
  }
}
