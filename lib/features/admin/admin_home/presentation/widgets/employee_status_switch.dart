import 'package:flutter/material.dart';

class EmployeeStatusSwitch extends StatelessWidget {
  final bool isActive;
  final ValueChanged<bool> onChanged;

  const EmployeeStatusSwitch({
    super.key,
    required this.isActive,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Text(
          'Active Status',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        const Spacer(),
        Switch(
          value: isActive,
          onChanged: onChanged,
          activeColor: const Color(0xFF0EA5E9),
        ),
      ],
    );
  }
}
