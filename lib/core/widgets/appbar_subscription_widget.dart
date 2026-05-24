import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:gymbook/core/theme/styles.dart';
import 'package:gymbook/core/widgets/custom_text.dart';

class AppbarSubscriptionWidget extends StatelessWidget {
  const AppbarSubscriptionWidget({
    super.key,
    required this.text,
    this.subtitle,
    this.onBack,
    this.showBackButton = true,
  });

  final String text;
  final String? subtitle;
  final VoidCallback? onBack;
  final bool showBackButton;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF0EA5E9), Color(0xFF0284C7)],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(28.r),
          bottomRight: Radius.circular(28.r),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 40.h),

            Row(
              children: [
                if (showBackButton) ...[
                  GestureDetector(
                    onTap: () {
                      if (onBack != null) {
                        onBack!();
                      } else {
                        GoRouter.of(context).pop();
                      }
                    },
                    child: const Icon(Icons.arrow_back, color: Colors.white),
                  ),
                  SizedBox(width: 16.w),
                ],
                AppText(text, style: font20w700.copyWith(color: Colors.white)),
              ],
            ),
            if (subtitle != null) ...[
              SizedBox(height: 8.h),
              Padding(
                padding: EdgeInsets.only(left: showBackButton ? 40.w : 0),
                child: AppText(
                  subtitle!,
                  style: font14w500.copyWith(
                    color: Colors.white.withOpacity(
                      0.9,
                    ), // ignore: deprecated_member_use
                  ),
                ),
              ),
            ],

            SizedBox(height: 22.h),
          ],
        ),
      ),
    );
  }
}
