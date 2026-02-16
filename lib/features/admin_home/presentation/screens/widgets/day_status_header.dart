import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gymbook/core/theme/styles.dart';
import 'package:gymbook/core/widgets/custom_text.dart';
import 'package:gymbook/features/home/presentation/screens/widgets/switch_open_gym.dart';

class DayStatusHeader extends StatelessWidget {
  final String day;
  final bool isOpen;
  final ValueChanged<bool> onToggle;

  const DayStatusHeader({
    super.key,
    required this.day,
    required this.isOpen,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(
              Icons.calendar_month,
              size: 24.sp,
              color: const Color(0xFF0EA5E9),
            ),
            SizedBox(width: 8.w),
            AppText(
              day,
              style: font18w700.copyWith(
                color: isOpen
                    ? const Color(0xff364153)
                    : const Color(0xff9CA3AF),
              ),
            ),
          ],
        ),
        Row(
          children: [
            AppText(
              isOpen ? 'Open' : 'Closed',
              style: font14w500.copyWith(
                color: isOpen
                    ? const Color(0xff10B981)
                    : const Color(0xffEF4444),
              ),
            ),
            SizedBox(width: 8.w),
            OpenGymSwitch(value: isOpen, onChanged: onToggle),
          ],
        ),
      ],
    );
  }
}
