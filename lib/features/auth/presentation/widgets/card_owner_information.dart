import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gymbook/core/theme/styles.dart';
import 'package:gymbook/core/widgets/custom_text.dart';

class CardOwnerInformation extends StatelessWidget {
  const CardOwnerInformation({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(color: const Color(0xffDBEAFE), width: 1.w),
        boxShadow: [
          BoxShadow(
            // ignore: deprecated_member_use
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20.r,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(
            'Owner Information',
            style: font14w700.copyWith(color: const Color(0xff0EA5E9)),
          ),
          SizedBox(height: 4.h),
          AppText(
            'We need your contact details to verify your identity',
            style: font14w400.copyWith(color: const Color(0xff4A5565)),
            maxLines: 2,
          ),
        ],
      ),
    );
  }
}
