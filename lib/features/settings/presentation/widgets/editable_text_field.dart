import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gymbook/core/theme/styles.dart';
import 'package:gymbook/core/widgets/custom_text.dart';

class EditableTextField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final IconData icon;
  final TextInputType? inputType;
  final VoidCallback onEditTap;
  final bool isEditable;
  final FocusNode focusNode;

  const EditableTextField({
    super.key,
    required this.label,
    required this.controller,
    required this.icon,
    required this.onEditTap,
    required this.isEditable,
    required this.focusNode,
    this.inputType,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(label, style: font14w700.copyWith(color: Colors.grey[700])),
          SizedBox(height: 8.h),
          TextFormField(
            controller: controller,
            keyboardType: inputType,
            focusNode: focusNode,
            readOnly: !isEditable,
            style: font16w500.copyWith(
              color: isEditable ? Colors.black87 : Colors.black54,
            ),
            decoration: InputDecoration(
              prefixIcon: Icon(icon, size: 22.sp),
              suffixIcon: IconButton(
                onPressed: onEditTap,
                icon: Icon(
                  isEditable ? Icons.check_circle : Icons.edit_square,
                  color: isEditable ? Colors.green : const Color(0xFF134FA2),
                  size: isEditable ? 24.sp : 20.sp,
                ),
                splashRadius: 24,
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16.w,
                vertical: 14.h,
              ),
              filled: true,
              fillColor: isEditable ? Colors.white : Colors.grey[50],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: const BorderSide(color: Color(0xFF134FA2)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
