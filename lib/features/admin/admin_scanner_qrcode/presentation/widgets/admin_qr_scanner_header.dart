import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gymbook/core/widgets/custom_icon_appbar_widget.dart';

class AdminQrScannerHeader extends StatelessWidget {
  const AdminQrScannerHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: CustomIconAppbarWidget(
        text: 'Check-In Scanner',
        subtitle: 'Scan customer QR to verify',
        customIcon: Container(
          padding: EdgeInsets.all(10.w),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Icon(Icons.qr_code_scanner, color: Colors.white, size: 28.w),
        ),
      ),
    );
  }
}
