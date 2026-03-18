import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:gymbook/core/theme/styles.dart';
import 'package:gymbook/core/widgets/custom_text.dart';

class GovernorateDropdown extends StatefulWidget {
  final String? initialValue;
  final List<GovernorateDropdownItem> governorates;
  final bool isLoading;
  final VoidCallback? onMenuOpen;
  final void Function(String?)? onChanged;
  final void Function(int?)? onChangedId;
  final String? hintText;
  final String? labelText;
  final Color? borderColor;
  final double? borderRadius;
  final Color? backgroundColor;

  const GovernorateDropdown({
    super.key,
    this.initialValue,
    this.governorates = const [],
    this.isLoading = false,
    this.onMenuOpen,
    this.onChanged,
    this.onChangedId,
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

  @override
  void initState() {
    super.initState();
    selectedGovernorate = widget.initialValue;
  }

  int? _selectedGovernorateId() {
    if (selectedGovernorate == null) return null;
    for (final governorate in widget.governorates) {
      if (governorate.name == selectedGovernorate) {
        return governorate.id;
      }
    }
    return null;
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
            onMenuStateChange: (isOpen) {
              if (isOpen) {
                widget.onMenuOpen?.call();
              }
            },
            hint: AppText(
              widget.isLoading
                  ? 'Loading governorates...'
                  : widget.hintText ?? 'Choose governorate',
              alignment: AlignmentDirectional.centerStart,
              style: font14w500.copyWith(color: const Color(0xff9CA3AF)),
            ),
            value: selectedGovernorate,
            onChanged: widget.isLoading
                ? null
                : (String? value) {
                    setState(() {
                      selectedGovernorate = value;
                    });
                    widget.onChanged?.call(value);
                    widget.onChangedId?.call(_selectedGovernorateId());
                  },
            items: widget.governorates
                .map(
                  (item) => DropdownMenuItem<String>(
                    value: item.name,
                    child: AppText(
                      item.name,
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

class GovernorateDropdownItem {
  final int id;
  final String name;

  const GovernorateDropdownItem({required this.id, required this.name});
}
