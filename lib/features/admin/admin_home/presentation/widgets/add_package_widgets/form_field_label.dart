import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gymbook/core/theme/styles.dart';
import 'package:gymbook/core/widgets/custom_text.dart';

class FormFieldLabel extends StatelessWidget {
  final String text;

  const FormFieldLabel({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 6.h),
      child: AppText(
        text,
        style: font14w700.copyWith(color: const Color(0xff364153)),
      ),
    );
  }
}
