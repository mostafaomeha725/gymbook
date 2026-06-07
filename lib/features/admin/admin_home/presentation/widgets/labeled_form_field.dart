import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gymbook/core/theme/styles.dart';
import 'package:gymbook/core/widgets/custom_text.dart';

class LabeledFormField extends StatelessWidget {
  final String label;
  final Widget input;

  const LabeledFormField({super.key, required this.label, required this.input});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(label, style: font14w700.copyWith(color: Colors.black87)),
        SizedBox(height: 8.h),
        input,
      ],
    );
  }
}
