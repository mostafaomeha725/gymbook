import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gymbook/core/theme/styles.dart';
import 'package:gymbook/core/widgets/custom_text.dart';
import 'package:gymbook/features/auth/presentation/screens/widgets/gym_type_selector.dart';

class GymTypeItem extends StatelessWidget {
  final String title;
  final GymType value;
  final GymType? groupValue;
  final ValueChanged<GymType> onChanged;

  const GymTypeItem({
    super.key,
    required this.title,
    required this.value,
    required this.groupValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final bool isSelected = value == groupValue;

    return GestureDetector(
      onTap: () => onChanged(value),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 18.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: isSelected
                ? const Color(0xff0EA5E9)
                : const Color(0xffE5E7EB),
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            Radio<GymType>(
              value: value,
              groupValue: groupValue,
              onChanged: (val) {
                if (val != null) onChanged(val);
              },
              activeColor: const Color(0xff0EA5E9),
            ),
            SizedBox(width: 8.w),
            AppText(title, style: font16w500.copyWith(color: Colors.black)),
          ],
        ),
      ),
    );
  }
}
