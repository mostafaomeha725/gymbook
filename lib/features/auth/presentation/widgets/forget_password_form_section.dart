import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:gymbook/core/theme/styles.dart';
import 'package:gymbook/core/utils/validators.dart';
import 'package:gymbook/core/widgets/app_form_field.dart';
import 'package:gymbook/core/widgets/custom_button.dart';
import 'package:gymbook/core/widgets/custom_text.dart';
import 'package:gymbook/features/auth/presentation/widgets/auth_icon_badge.dart';

class ForgetPasswordFormSection extends StatelessWidget {
  const ForgetPasswordFormSection({
    super.key,
    required this.formKey,
    required this.emailController,
    required this.formSubmitted,
    required this.onSubmit,
    required this.onEmailChanged,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final bool formSubmitted;
  final VoidCallback onSubmit;
  final ValueChanged<String> onEmailChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 48.w),
      child: Column(
        children: [
          SizedBox(height: 28.h),
          const AuthIconBadge(),
          SizedBox(height: 20.h),
          AppText(
            'Enter Your Email',
            alignment: AlignmentDirectional.center,
            style: font24w700.copyWith(color: const Color(0xff364153)),
          ),
          SizedBox(height: 8.h),
          AppText(
            "We'll send a 6-digit verification code to your inbox",
            textAlign: TextAlign.center,
            style: font16w400.copyWith(color: const Color(0xff6B7280)),
            maxLines: 2,
          ),
          SizedBox(height: 30.h),
          Form(
            key: formKey,
            child: AppFormField(
              controller: emailController,
              hintText: 'example@email.com',
              maxLines: 1,
              keyboardType: TextInputType.emailAddress,
              radius: 14.r,
              fillColor: Colors.white,
              prefixIcon: Padding(
                padding: EdgeInsets.only(left: 8.w),
                child: Icon(
                  Icons.email_outlined,
                  size: 22.sp,
                  color: const Color(0xff9CA3AF),
                ),
              ),
              onChanged: onEmailChanged,
              validator: (value) {
                if (!formSubmitted) return null;
                return Validators.email(value);
              },
            ),
          ),
          SizedBox(height: 22.h),
          AppButton(
            text: 'Send Reset Code',
            onPressed: onSubmit,
            textSize: 16.sp,
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF0EA5E9), Color(0xFF0284C7)],
            ),
          ),
          SizedBox(height: 18.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AppText(
                'Remember your password? ',
                style: font14w400.copyWith(color: const Color(0xff6B7280)),
              ),
              GestureDetector(
                onTap: () => GoRouter.of(context).pop(),
                child: AppText(
                  'Login',
                  style: font14w700.copyWith(color: const Color(0xFF0284C7)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
