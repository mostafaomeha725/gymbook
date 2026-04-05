import 'package:flutter/material.dart';
import 'package:gymbook/core/theme/styles.dart';
import 'package:gymbook/core/widgets/custom_text.dart';

class AddBranchFourSectionTitle extends StatelessWidget {
  final String title;

  const AddBranchFourSectionTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: AlignmentDirectional.centerStart,
      child: AppText(
        title,
        style: font14w500.copyWith(color: const Color(0xff364153)),
      ),
    );
  }
}
