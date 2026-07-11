import 'package:flutter/material.dart';
import 'package:gymbook/core/theme/styles.dart';
import 'package:gymbook/core/widgets/custom_text.dart';

class SubscriptionInfoRow extends StatelessWidget {
  final String title;
  final String value;

  const SubscriptionInfoRow({
    super.key,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        AppText(title, style: font16w400.copyWith(color: Colors.grey[600])),
        AppText(
          value,
          style: font16w700.copyWith(color: const Color(0xff2E3A46)),
        ),
      ],
    );
  }
}
