import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gymbook/core/theme/styles.dart';
import 'package:gymbook/core/widgets/custom_button.dart';
import 'package:gymbook/core/widgets/custom_text.dart';
import 'package:gymbook/features/auth/presentation/widgets/text_join_member.dart';

class JoinAsMemberCard extends StatelessWidget {
  const JoinAsMemberCard({
    super.key,
    required this.color,
    required this.text,
    required this.text1,
    required this.text2,
    required this.textbutton,
    required this.onpressed,
    required this.icon,
  });
  final Color color;
  final List text;
  final String text1;
  final String text2;
  final String textbutton;
  final void Function() onpressed;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.w),
      margin: EdgeInsets.symmetric(horizontal: 46.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(color: color, width: 1.2.w),
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
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 52.h,
                width: 52.w,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Icon(icon, color: Colors.white, size: 26.sp),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(text1, style: font20w700),
                    SizedBox(height: 4.h),
                    AppText(
                      text2,
                      style: font14w400.copyWith(
                        color: const Color(0xff4A5565),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: 20.h),

          TextJoinMember(color: color, text: text[0]),
          TextJoinMember(color: color, text: text[1]),
          TextJoinMember(color: color, text: text[2]),
          TextJoinMember(color: color, text: text[3]),

          SizedBox(height: 24.h),

          AppButton(
            text: textbutton,
            onPressed: onpressed,
            color: color,
            textSize: 16.sp,
          ),
        ],
      ),
    );
  }
}
