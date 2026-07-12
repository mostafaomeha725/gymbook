import 'package:flutter/material.dart';
import 'package:gymbook/features/admin/admin_home/presentation/widgets/add_package_widgets/form_field_label.dart';

class PackageStatusSwitch extends StatelessWidget {
  final bool isActive;
  final ValueChanged<bool> onChanged;

  const PackageStatusSwitch({
    super.key,
    required this.isActive,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const FormFieldLabel(text: 'Active'),
        Switch.adaptive(
          value: isActive,
          activeColor: const Color(0xFF0EA5E9),
          onChanged: onChanged,
        ),
      ],
    );
  }
}
