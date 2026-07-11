import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gymbook/core/theme/styles.dart';
import 'package:gymbook/core/widgets/custom_text.dart';
import 'package:gymbook/core/widgets/in_app_notification_popup/notification_style.dart';
import 'package:gymbook/features/notifications/domain/entities/notification_entity.dart';
import 'package:timeago/timeago.dart' as timeago;

class NotificationItemWidget extends StatelessWidget {
  final NotificationEntity notification;
  final VoidCallback onTap;

  const NotificationItemWidget({
    super.key,
    required this.notification,
    required this.onTap,
  });

  List<TextSpan> _parseMessageBold(String text, bool isRead) {
    final textColor = isRead ? Colors.grey.shade600 : Colors.grey.shade800;
    final spans = <TextSpan>[];

    // Simple parsing to make words in single quotes bold
    final regex = RegExp(r"'(.*?)'");
    int lastMatchEnd = 0;

    for (var match in regex.allMatches(text)) {
      if (match.start > lastMatchEnd) {
        spans.add(
          TextSpan(
            text: text.substring(lastMatchEnd, match.start),
            style: font12w400.copyWith(color: textColor, height: 1.4),
          ),
        );
      }
      spans.add(
        TextSpan(
          text: match.group(1), // without quotes
          style: font12w700.copyWith(color: textColor, height: 1.4),
        ),
      );
      lastMatchEnd = match.end;
    }

    if (lastMatchEnd < text.length) {
      spans.add(
        TextSpan(
          text: text.substring(lastMatchEnd),
          style: font12w400.copyWith(color: textColor, height: 1.4),
        ),
      );
    }

    return spans.isEmpty
        ? [
            TextSpan(
              text: text,
              style: font12w400.copyWith(color: textColor, height: 1.4),
            ),
          ]
        : spans;
  }

  @override
  Widget build(BuildContext context) {
    final style = NotificationStyle.getStyleForType(
      notification.notificationType,
    );

    // Facebook style backgrounds
    final bgColor = notification.isRead
        ? Colors.white
        : const Color(0xFFE7F3FF);

    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        decoration: BoxDecoration(color: bgColor),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile / Icon with Badge
            SizedBox(
              width: 56.w,
              height: 56.w,
              child: Stack(
                children: [
                  Container(
                    width: 56.w,
                    height: 56.w,
                    decoration: BoxDecoration(
                      // ignore: deprecated_member_use
                      color: style.color.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(style.icon, color: style.color, size: 28.w),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 20.w,
                      height: 20.w,
                      decoration: BoxDecoration(
                        color: style.color,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: Icon(style.icon, color: Colors.white, size: 10.w),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 12.w),
            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  AppText(
                    notification.title,
                    style: font14w700.copyWith(
                      color: notification.isRead
                          ? Colors.grey.shade800
                          : Colors.black,
                      height: 1.4,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  // Subtitle (Message)
                  RichText(
                    text: TextSpan(
                      children: _parseMessageBold(
                        notification.message,
                        notification.isRead,
                      ),
                    ),
                  ),
                  SizedBox(height: 4.h),
                  // Timestamp
                  AppText(
                    timeago.format(notification.createdAt, locale: 'en_short'),
                    style: font12w500.copyWith(
                      color: notification.isRead
                          ? Colors.grey.shade600
                          : Colors.blue.shade700,
                    ),
                  ),
                ],
              ),
            ),
            // Unread dot
            if (!notification.isRead)
              Padding(
                padding: EdgeInsets.only(top: 8.h, left: 8.w),
                child: Container(
                  width: 10.w,
                  height: 10.w,
                  decoration: const BoxDecoration(
                    color: Color(0xFF0284C7),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
