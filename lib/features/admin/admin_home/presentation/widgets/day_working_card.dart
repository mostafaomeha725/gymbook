import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gymbook/core/theme/styles.dart';
import 'package:gymbook/core/widgets/custom_text.dart';
import 'package:gymbook/features/admin/admin_home/presentation/widgets/day_status_header.dart';
import 'package:gymbook/features/admin/admin_home/presentation/widgets/time_picker_field.dart';

class DayWorkingCard extends StatelessWidget {
  final String day;
  final bool isOpen;
  final TextEditingController openTimeController;
  final TextEditingController closeTimeController;
  final ValueChanged<bool> onStatusChanged;
  final ValueChanged<String>? onOpenTimeChanged;
  final ValueChanged<String>? onCloseTimeChanged;

  const DayWorkingCard({
    super.key,
    required this.day,
    required this.isOpen,
    required this.openTimeController,
    required this.closeTimeController,
    required this.onStatusChanged,
    this.onOpenTimeChanged,
    this.onCloseTimeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: const Color(0xffE5E7EB)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DayStatusHeader(
              day: day,
              isOpen: isOpen,
              onToggle: onStatusChanged,
            ),
            if (isOpen) ...[
              SizedBox(height: 12.h),
              Row(
                children: [
                  Expanded(
                    child: TimePickerField(
                      label: 'Opening Time',
                      controller: openTimeController,
                      onTimeSelected: onOpenTimeChanged,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: TimePickerField(
                      label: 'Closing Time',
                      controller: closeTimeController,
                      onTimeSelected: onCloseTimeChanged,
                    ),
                  ),
                ],
              ),
            ] else ...[
              SizedBox(height: 8.h),
              Container(
                padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
                decoration: BoxDecoration(
                  color: const Color(0xffF3F4F6),
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(color: const Color(0xffE5E7EB)),
                ),
                child: AppText(
                  'Branch is closed on this day',
                  style: font14w500.copyWith(color: const Color(0xff4A5565)),
                  alignment: AlignmentDirectional.center,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
