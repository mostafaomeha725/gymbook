import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gymbook/core/widgets/custom_text.dart';
import 'package:gymbook/core/theme/styles.dart';
import 'freeze_available_box.dart';

class FreezeInformationCard extends StatelessWidget {
  const FreezeInformationCard({super.key, required this.freezes});

  final int freezes;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 22.w, vertical: 12.h),
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: const Color(0xffEAF4FF),
        borderRadius: BorderRadius.circular(26.r),
        border: Border.all(color: const Color(0xff9ED0FF)),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withAlpha(38),
            blurRadius: 16.r,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Stack(
        children: [
          /// ❄️ Snow decoration
          Positioned(
            right: 10.w,
            top: 10.h,
            child: Icon(
              Icons.ac_unit,
              size: 60.sp,
              color: Colors.blue.withAlpha(38),
            ),
          ),
          Positioned(
            left: 0,
            bottom: 0,
            child: Icon(
              Icons.ac_unit,
              size: 40.sp,
              color: Colors.blue.withAlpha(30),
            ),
          ),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 60.w,
                    height: 60.w,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF3B82F6), Color(0xFF2563EB)],
                      ),
                      borderRadius: BorderRadius.circular(18.r),
                    ),
                    child: Icon(
                      Icons.ac_unit,
                      color: Colors.white,
                      size: 28.sp,
                    ),
                  ),
                  SizedBox(width: 14.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText(
                        "Freeze Information",
                        style: font20w700.copyWith(
                          color: const Color(0xff334155),
                        ),
                      ),
                      SizedBox(height: 4.h),
                      AppText(
                        "Pause subscription temporarily",
                        style: font14w500.copyWith(
                          color: const Color(0xff64748B),
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              SizedBox(height: 20.h),

              FreezeAvailableBox(freezes: freezes),
            ],
          ),
        ],
      ),
    );
  }
}
