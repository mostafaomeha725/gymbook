import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gymbook/core/theme/styles.dart';
import 'package:gymbook/core/widgets/app_form_field.dart';
import 'package:gymbook/core/widgets/custom_text.dart';

class LabeledAuthField extends StatefulWidget {
  final String label;
  final String hintText;
  final TextEditingController controller;
  final IconData? prefixIcon;
  final Widget? prefixWidget;
  final TextInputType keyboardType;
  final bool isPassword;
  final bool hasBottomSpacing;

  const LabeledAuthField({
    super.key,
    required this.label,
    required this.hintText,
    required this.controller,
    this.prefixIcon,
    this.prefixWidget,
    this.keyboardType = TextInputType.text,
    this.isPassword = false,
    this.hasBottomSpacing = true,
  });

  @override
  State<LabeledAuthField> createState() => _LabeledAuthFieldState();
}

class _LabeledAuthFieldState extends State<LabeledAuthField> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.isPassword;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(
          widget.label,
          style: font14w500.copyWith(color: const Color(0xff364153)),
        ),
        SizedBox(height: 8.h),
        AppFormField(
          controller: widget.controller,
          hintText: widget.hintText,
          maxLines: 1,
          keyboardType: widget.keyboardType,
          obsecureText: _obscureText,
          prefixIcon:
              widget.prefixWidget ??
              (widget.prefixIcon != null
                  ? Padding(
                      padding: EdgeInsets.only(left: 8.w),
                      child: Icon(widget.prefixIcon, size: 16.sp),
                    )
                  : null),
          radius: 22.r,
          suffixIcon: widget.isPassword
              ? IconButton(
                  icon: Icon(
                    _obscureText
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                  ),
                  onPressed: () => setState(() => _obscureText = !_obscureText),
                )
              : null,
        ),
        if (widget.hasBottomSpacing) SizedBox(height: 16.h),
      ],
    );
  }
}
