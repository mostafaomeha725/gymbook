import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:gymbook/core/theme/styles.dart';
import 'package:gymbook/core/widgets/custom_text.dart';

class GovernorateDropdown extends StatefulWidget {
  final String? initialValue;
  final void Function(String?)? onChanged;
  final String? hintText;
  final String? labelText;
  final Color? borderColor;
  final double? borderRadius;
  final Color? backgroundColor;

  const GovernorateDropdown({
    super.key,
    this.initialValue,
    this.onChanged,
    this.hintText,
    this.labelText,
    this.borderColor,
    this.borderRadius,
    this.backgroundColor,
  });

  @override
  State<GovernorateDropdown> createState() => _GovernorateDropdownState();
}

class _GovernorateDropdownState extends State<GovernorateDropdown> {
  late String? selectedGovernorate;

  final List<String> governorates = [
    'Cairo',
    'Alexandria',
    'Giza',
    'Qalyubia',
    'Helwan',
    'Suez',
    'Port Said',
    'Ismalia',
    'Damietta',
    'Dakahlia',
    'Mansoura',
    'Kafr El-Sheikh',
    'Gharbia',
    'Monufia',
    'Beheira',
    'Matruh',
    'North Sinai',
    'South Sinai',
    'Fayoum',
    'Beni Suef',
    'Minya',
    'Assiut',
    'Sohag',
    'Qena',
    'Luxor',
    'Aswan',
    'New Valley',
    'Red Sea',
  ];

  @override
  void initState() {
    super.initState();
    selectedGovernorate = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.labelText != null) ...[
          AppText(
            widget.labelText!,
            style: font14w500.copyWith(color: const Color(0xff364153)),
          ),
          SizedBox(height: 8.h),
        ],
        DropdownButtonHideUnderline(
          child: DropdownButton2<String>(
            isExpanded: true,
            hint: AppText(
              widget.hintText ?? 'Choose governorate',
              alignment: AlignmentDirectional.centerStart,
              style: font14w500.copyWith(color: const Color(0xff9CA3AF)),
            ),
            value: selectedGovernorate,
            onChanged: (String? value) {
              setState(() {
                selectedGovernorate = value;
              });
              widget.onChanged?.call(value);
            },
            items: governorates
                .map(
                  (item) => DropdownMenuItem<String>(
                    value: item,
                    child: AppText(
                      item,
                      style: font14w500,
                      alignment: AlignmentDirectional.centerStart,
                    ),
                  ),
                )
                .toList(),
            buttonStyleData: ButtonStyleData(
              height: 50.h,
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(
                  widget.borderRadius ?? 12.r,
                ),
                border: Border.all(
                  color: widget.borderColor ?? const Color(0xffE5E7EB),
                ),
                color: widget.backgroundColor ?? Colors.white,
              ),
            ),
            iconStyleData: IconStyleData(
              icon: Icon(Icons.arrow_drop_down, size: 24.sp),
              openMenuIcon: Icon(Icons.arrow_drop_up, size: 24.sp),
            ),
            dropdownStyleData: DropdownStyleData(
              maxHeight: 300.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(
                  widget.borderRadius ?? 12.r,
                ),
                color: Colors.white,
              ),
            ),
            menuItemStyleData: MenuItemStyleData(
              height: 45.h,
              padding: EdgeInsets.symmetric(horizontal: 12.w),
            ),
          ),
        ),
      ],
    );
  }
}
