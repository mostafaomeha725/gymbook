import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gymbook/core/theme/styles.dart';
import 'package:gymbook/core/widgets/custom_text.dart';

class PasswordConditionsWidget extends StatelessWidget {
  final String password;
  final String confirmPassword;

  const PasswordConditionsWidget({
    super.key,
    required this.password,
    required this.confirmPassword,
  });

  bool get hasMinLength => password.length >= 8;
  bool get hasUpperCase => password.contains(RegExp(r'[A-Z]'));
  bool get hasLowerCase => password.contains(RegExp(r'[a-z]'));
  bool get hasNumberOrSymbol => password.contains(RegExp(r'[0-9!@#\$&*~]'));
  bool get isMatch => password.isNotEmpty && password == confirmPassword;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _condition('At least 8 characters', hasMinLength),
          _condition('At least one upper-case letter', hasUpperCase),
          _condition('At least one lower-case letter', hasLowerCase),
          _condition('At least one number or symbol', hasNumberOrSymbol),
          _condition(
            isMatch ? 'Passwords match' : 'Passwords do not match',
            isMatch,
          ),
        ],
      ),
    );
  }

  Widget _condition(String text, bool isValid) {
    return Padding(
      padding: EdgeInsets.only(bottom: 6.h),
      child: Row(
        children: [
          Icon(
            isValid ? Icons.check_circle : Icons.radio_button_unchecked,
            size: 18.sp,
            color: isValid ? Colors.green : const Color(0xff9CA3AF),
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: AppText(
              text,
              style: font12w400.copyWith(
                color: isValid ? Colors.green : const Color(0xff6B7280),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
