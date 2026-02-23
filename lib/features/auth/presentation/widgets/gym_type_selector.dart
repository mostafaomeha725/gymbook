import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gymbook/core/theme/styles.dart';
import 'package:gymbook/core/widgets/custom_text.dart';
import 'package:gymbook/features/auth/presentation/widgets/gym_type_item.dart';
export 'package:gymbook/core/enums/app_enums.dart' show GymType;
import 'package:gymbook/core/enums/app_enums.dart' show GymType;

class GymTypeSelector extends StatefulWidget {
  final GymType? initialValue;
  final ValueChanged<GymType> onChanged;

  const GymTypeSelector({
    super.key,
    this.initialValue,
    required this.onChanged,
  });

  @override
  State<GymTypeSelector> createState() => _GymTypeSelectorState();
}

class _GymTypeSelectorState extends State<GymTypeSelector> {
  GymType? _selectedType;

  @override
  void initState() {
    super.initState();
    _selectedType = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(
          'Gym Type',
          style: font14w500.copyWith(color: const Color(0xff364153)),
        ),
        SizedBox(height: 12.h),

        GymTypeItem(
          title: 'Men Only',
          value: GymType.menOnly,
          groupValue: _selectedType,
          onChanged: _onChanged,
        ),

        SizedBox(height: 12.h),

        GymTypeItem(
          title: 'Women Only',
          value: GymType.womenOnly,
          groupValue: _selectedType,
          onChanged: _onChanged,
        ),

        SizedBox(height: 12.h),

        GymTypeItem(
          title: 'Mixed (Men & Women)',
          value: GymType.mixed,
          groupValue: _selectedType,
          onChanged: _onChanged,
        ),
      ],
    );
  }

  void _onChanged(GymType value) {
    setState(() {
      _selectedType = value;
    });
    widget.onChanged(value);
  }
}
