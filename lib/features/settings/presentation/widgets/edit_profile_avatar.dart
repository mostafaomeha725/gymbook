import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gymbook/core/theme/styles.dart';
import 'package:gymbook/core/widgets/custom_text.dart';

class EditProfileAvatar extends StatelessWidget {
  final String firstName;
  final String lastName;
  final bool isLoading;

  const EditProfileAvatar({
    super.key,
    required this.firstName,
    required this.lastName,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    final firstNameInit = firstName.isNotEmpty ? firstName[0] : '';
    final lastNameInit = lastName.isNotEmpty ? lastName[0] : '';
    final initials = '$firstNameInit$lastNameInit'.toUpperCase();

    return Container(
      width: 78.w,
      height: 78.h,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [Color(0xFF0EA5E9), Color(0xFF0284C7)],
        ),
      ),
      alignment: Alignment.center,
      child: isLoading
          ? const CircularProgressIndicator(color: Colors.white)
          : AppText(
              initials,
              style: font20w500.copyWith(color: Colors.white),
              alignment: AlignmentDirectional.center,
            ),
    );
  }
}
