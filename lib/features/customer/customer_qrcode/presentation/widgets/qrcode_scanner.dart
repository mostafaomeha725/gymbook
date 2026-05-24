import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gymbook/core/theme/styles.dart';
import 'package:gymbook/core/widgets/bouncing_social_button.dart';
import 'package:gymbook/core/widgets/custom_text.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QrcodeScanner extends StatelessWidget {
  final int? userId;
  final String code;
  final String qrData;
  final int secondsRemaining;
  final bool isLoading;
  final VoidCallback onRefreshTap;

  const QrcodeScanner({
    super.key,
    required this.userId,
    required this.code,
    required this.qrData,
    required this.secondsRemaining,
    required this.isLoading,
    required this.onRefreshTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 30.r,
            spreadRadius: 2.r,
            offset: const Offset(0, 15),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: const Color(0xFF0284C7),
                    width: 3.w,
                  ),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Container(
                  width: 200.w,
                  height: 200.w,
                  color: Colors.white,
                  alignment: Alignment.center,
                  child: isLoading
                      ? AppText(
                          '......',
                          style: font24w700.copyWith(
                            color: const Color(0xFF0284C7),
                            letterSpacing: 2,
                          ),
                          alignment: AlignmentDirectional.center,
                        )
                      : QrImageView(
                          data: qrData,
                          version: QrVersions.auto,
                          size: 180.w,
                          backgroundColor: Colors.white,
                          foregroundColor: const Color(0xFF0F172A),
                        ),
                ),
              ),

              /// Timer Circle
              Positioned(
                bottom: -35.h,
                child: Container(
                  width: 64.w,
                  height: 64.w,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFF0284C7),
                  ),
                  alignment: Alignment.center,
                  child: AppText(
                    '${secondsRemaining}s',
                    style: font16w700.copyWith(color: Colors.white),
                    alignment: AlignmentDirectional.center,
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 40.h),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AppText(
                "Code expires in ",
                style: font16w400.copyWith(color: Colors.grey),
              ),
              AppText(
                '00:${secondsRemaining.toString().padLeft(2, '0')}',
                style: font16w700.copyWith(color: const Color(0xFF0284C7)),
              ),
            ],
          ),

          // SizedBox(height: 12.h),

          // AppText(
          //   'User ID: ${userId ?? '--'}',
          //   style: font14w500.copyWith(color: const Color(0xff334155)),
          //   alignment: AlignmentDirectional.center,
          // ),
          // SizedBox(height: 4.h),
          // AppText(
          //   'Code: ${isLoading ? '------' : code}',
          //   style: font14w500.copyWith(color: const Color(0xff334155)),
          //   alignment: AlignmentDirectional.center,
          // ),
          SizedBox(height: 30.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 42.w),
            child: BouncingSocialButton(
              text: 'Refresh Code',
              borderColor: const Color(0XFF0EA5E9),
              icon: Icons.refresh,
              onTap: onRefreshTap,
              textSize: 14.sp,
              textColor: const Color(0XFF0EA5E9),
            ),
          ),
        ],
      ),
    );
  }
}
