import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gymbook/core/theme/styles.dart';
import 'package:gymbook/core/widgets/custom_text.dart';

class NotificationStatusSheet extends StatelessWidget {
  final bool isEnabled;

  const NotificationStatusSheet({super.key, required this.isEnabled});

  static void show(BuildContext context, {required bool isEnabled}) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => NotificationStatusSheet(isEnabled: isEnabled),
    );
  }

  @override
  Widget build(BuildContext context) {
    final message = isEnabled
        ? "Notifications enabled successfully"
        : "Notifications disabled successfully";
    final iconColor = isEnabled ? Colors.green : Colors.grey;
    final iconData = isEnabled
        ? Icons.notifications_active_rounded
        : Icons.notifications_off_rounded;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 30.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 50.w,
            height: 5.h,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(10.r),
            ),
          ),
          SizedBox(height: 30.h),
          TweenAnimationBuilder<double>(
            tween: Tween<double>(begin: 0.0, end: 1.0),
            duration: const Duration(milliseconds: 600),
            curve: Curves.elasticOut,
            builder: (context, value, child) {
              return Transform.scale(
                scale: value,
                child: Container(
                  padding: EdgeInsets.all(20.r),
                  decoration: BoxDecoration(
                    color: iconColor.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(iconData, color: iconColor, size: 60.r),
                ),
              );
            },
          ),
          SizedBox(height: 24.h),
          AppText(
            message,
            style: font18w700,
            alignment: AlignmentDirectional.center,
          ),
          SizedBox(height: 10.h),
          AppText(
            isEnabled
                ? "You will now receive all notifications and latest updates"
                : "You will no longer receive notifications. You can enable them again at any time",
            style: font14w400.copyWith(color: Colors.grey.shade600),
            alignment: AlignmentDirectional.center,
            maxLines: 2,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 30.h),
        ],
      ),
    );
  }
}
