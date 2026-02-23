import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gymbook/core/theme/styles.dart';
import 'package:gymbook/core/widgets/custom_text.dart';
import 'package:gymbook/core/widgets/app_form_field.dart';

class TimePickerField extends StatefulWidget {
  final String label;
  final TextEditingController controller;
  final void Function(String)? onTimeSelected;

  const TimePickerField({
    super.key,
    required this.label,
    required this.controller,
    this.onTimeSelected,
  });

  @override
  State<TimePickerField> createState() => _TimePickerFieldState();
}

class _TimePickerFieldState extends State<TimePickerField> {
  String _formatToApiTime(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute:00';
  }

  Future<void> _selectTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (picked != null) {
      final timeString = _formatToApiTime(picked);
      widget.controller.text = timeString;
      widget.onTimeSelected?.call(timeString);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(
          widget.label,
          style: font12w500.copyWith(color: const Color(0xff4A5565)),
        ),
        SizedBox(height: 4.h),
        AppFormField(
          controller: widget.controller,
          hintText: 'Select time',
          readOnly: true,
          onTap: _selectTime,
          suffixIcon: const Icon(Icons.access_time),
        ),
      ],
    );
  }
}
