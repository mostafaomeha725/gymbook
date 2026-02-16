import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gymbook/core/theme/styles.dart';
import 'package:gymbook/core/widgets/custom_text.dart';
import 'package:gymbook/features/home/presentation/screens/widgets/switch_open_gym.dart';

class ShowOnlyOpenGymsCard extends StatefulWidget {
  final bool initialValue;
  final ValueChanged<bool>? onChanged;

  const ShowOnlyOpenGymsCard({
    super.key,
    this.initialValue = false,
    this.onChanged,
  });

  @override
  State<ShowOnlyOpenGymsCard> createState() => _ShowOnlyOpenGymsCardState();
}

class _ShowOnlyOpenGymsCardState extends State<ShowOnlyOpenGymsCard> {
  late bool _value;

  @override
  void initState() {
    super.initState();
    _value = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        color: const Color(0xffE6F4FF),
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          /// Icon
          Icon(
            Icons.filter_alt_outlined,
            color: const Color(0xff0EA5E9),
            size: 26.sp,
          ),

          SizedBox(width: 12.w),

          /// Text
          Expanded(
            child: AppText(
              'Show only open gyms',
              style: font14w700.copyWith(color: const Color(0xff0EA5E9)),
            ),
          ),

          OpenGymSwitch(
            value: _value,
            onChanged: (value) {
              setState(() => _value = value);
              widget.onChanged?.call(value);
            },
          ),
        ],
      ),
    );
  }
}
