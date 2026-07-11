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
  late TextEditingController _displayController;

  @override
  void initState() {
    super.initState();
    _displayController = TextEditingController(
      text: _formatToDisplayTime(widget.controller.text),
    );
    widget.controller.addListener(_onSourceControllerChanged);
  }

  void _onSourceControllerChanged() {
    final newText = _formatToDisplayTime(widget.controller.text);
    if (_displayController.text != newText) {
      _displayController.text = newText;
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onSourceControllerChanged);
    _displayController.dispose();
    super.dispose();
  }

  String _formatToDisplayTime(String apiTime) {
    if (apiTime.trim().isEmpty) return '';
    final parts = apiTime.split(':');
    if (parts.length < 2) return apiTime;
    final h = int.tryParse(parts[0]);
    if (h == null) return apiTime;
    final isPM = h >= 12;
    final h12 = h == 0 ? 12 : (h > 12 ? h - 12 : h);
    return '${h12.toString().padLeft(2, '0')}:${parts[1].padLeft(2, '0')} ${isPM ? 'PM' : 'AM'}';
  }

  TimeOfDay _parseControllerTime(String value) {
    final parts = value.split(':');
    if (parts.length < 2) {
      return TimeOfDay.now();
    }

    final hour = int.tryParse(parts[0]);
    final minute = int.tryParse(parts[1]);

    if (hour == null || minute == null) {
      return TimeOfDay.now();
    }

    if (hour < 0 || hour > 23 || minute < 0 || minute > 59) {
      return TimeOfDay.now();
    }

    return TimeOfDay(hour: hour, minute: minute);
  }

  String _formatToApiTime(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute:00';
  }

  Future<void> _selectTime() async {
    final currentValue = widget.controller.text.trim();
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: currentValue.isEmpty
          ? TimeOfDay.now()
          : _parseControllerTime(currentValue),
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
          controller: _displayController,
          hintText: 'Select time',
          readOnly: true,
          onTap: _selectTime,
          suffixIcon: const Icon(Icons.access_time),
        ),
      ],
    );
  }
}
