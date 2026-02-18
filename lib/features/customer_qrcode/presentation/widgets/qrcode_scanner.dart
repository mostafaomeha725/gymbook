import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gymbook/core/constants/app_assets.dart';
import 'package:gymbook/core/theme/styles.dart';
import 'package:gymbook/core/widgets/app_asset.dart';
import 'package:gymbook/core/widgets/bouncing_social_button.dart';
import 'package:gymbook/core/widgets/custom_text.dart';

class QrcodeScanner extends StatelessWidget {
  const QrcodeScanner({super.key});

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
                  child: const AppAsset(
                    assetName: Assets.qrcodee,
                    fit: BoxFit.cover,
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
                    "56s",
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
                "00:56",
                style: font16w700.copyWith(color: const Color(0xFF0284C7)),
              ),
            ],
          ),

          SizedBox(height: 30.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 42.w),
            child: BouncingSocialButton(
              text: 'Refresh Code',
              borderColor: const Color(0XFF0EA5E9),
              icon: Icons.refresh,
              onTap: () {},
              textSize: 14.sp,
              textColor: const Color(0XFF0EA5E9),
            ),
          ),
        ],
      ),
    );
  }
}
