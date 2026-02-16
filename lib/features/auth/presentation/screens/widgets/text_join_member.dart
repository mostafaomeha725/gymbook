import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gymbook/core/theme/styles.dart';
import 'package:gymbook/core/widgets/custom_text.dart';

class TextJoinMember extends StatelessWidget {
  const TextJoinMember({super.key, required this.color, required this.text});
  final Color color;
  final String text;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Row(
        children: [
          Icon(Icons.check, color: color, size: 20),
          SizedBox(width: 10.w),
          Expanded(child: AppText(text, style: font14w400)),
        ],
      ),
    );
  }
}
