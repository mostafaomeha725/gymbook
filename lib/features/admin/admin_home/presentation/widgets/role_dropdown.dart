import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:gymbook/core/theme/dimensions.dart';
import 'package:gymbook/core/theme/styles.dart';
import 'package:gymbook/core/widgets/app_form_field.dart';
import 'package:gymbook/core/widgets/custom_text.dart';
import 'package:gymbook/features/admin/admin_home/data/models/role_model.dart';

class RoleDropdown extends StatefulWidget {
  final String? initialValue;
  final List<RoleModel> roles;
  final bool isLoading;
  final void Function(RoleModel?)? onChanged;
  final String? hintText;

  const RoleDropdown({
    super.key,
    this.initialValue,
    this.roles = const [],
    this.isLoading = false,
    this.onChanged,
    this.hintText,
  });

  @override
  State<RoleDropdown> createState() => _RoleDropdownState();
}

class _RoleDropdownState extends State<RoleDropdown> {
  late String? selectedRole;
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    selectedRole = widget.initialValue;
    _controller = TextEditingController(text: selectedRole);
  }

  @override
  void didUpdateWidget(covariant RoleDropdown oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialValue != oldWidget.initialValue) {
      selectedRole = widget.initialValue;
      _controller.text = selectedRole ?? '';
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton2<String>(
        isExpanded: true,
        customButton: IgnorePointer(
          child: AppFormField(
            controller: _controller,
            hintText: widget.isLoading
                ? 'Loading roles...'
                : (widget.hintText ?? 'Choose a role...'),
            readOnly: true,
            prefixIcon: const Icon(Icons.shield_outlined, size: 20),
            suffixIcon: const Icon(Icons.keyboard_arrow_down, size: 20),
          ),
        ),
        value: selectedRole,
        onChanged: widget.isLoading
            ? null
            : (String? value) {
                setState(() {
                  selectedRole = value;
                  _controller.text = value ?? '';
                });
                if (value != null) {
                  final role = widget.roles.firstWhere(
                    (element) => element.name == value,
                  );
                  widget.onChanged?.call(role);
                } else {
                  widget.onChanged?.call(null);
                }
              },
        items: widget.roles
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
        dropdownStyleData: DropdownStyleData(
          maxHeight: 300.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppDimensions.defaultRadius),
            color: Colors.white,
          ),
        ),
        menuItemStyleData: MenuItemStyleData(
          height: 45.h,
          padding: EdgeInsets.symmetric(horizontal: 16.w),
        ),
      ),
    );
  }
}
