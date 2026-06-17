import 'package:flutter/material.dart';
import 'package:gymbook/core/theme/styles.dart';

class ContactInfoRow extends StatelessWidget {
  final String label;
  final String value;

  const ContactInfoRow({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: font14w500.copyWith(color: Colors.grey[800]),
        children: [
          TextSpan(
            text: "$label: ",
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
          ),
          TextSpan(
            text: value,
            style: TextStyle(
              fontWeight: FontWeight.w400,
              color: Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }
}
