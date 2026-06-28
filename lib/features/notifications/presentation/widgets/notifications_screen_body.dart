import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gymbook/core/theme/styles.dart';
import 'package:gymbook/core/di/services_locator.dart';
import 'package:gymbook/core/widgets/custom_text.dart';
import 'package:gymbook/features/notifications/domain/entities/notification_entity.dart';
import 'package:gymbook/features/notifications/presentation/cubits/notifications_cubit/notifications_cubit.dart';
import 'package:gymbook/features/notifications/presentation/cubits/notifications_cubit/notifications_state.dart';
import 'package:gymbook/features/notifications/presentation/widgets/notification_item_widget.dart';

class NotificationsScreenBody extends StatefulWidget {
  const NotificationsScreenBody({super.key});

  @override
  State<NotificationsScreenBody> createState() => _NotificationsScreenBodyState();
}

class _NotificationsScreenBodyState extends State<NotificationsScreenBody> {
  final _cubit = sl<NotificationsCubit>();

  String _getSectionHeader(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final notificationDate = DateTime(date.year, date.month, date.day);

    if (notificationDate == today) {
      return 'Today';
    } else if (notificationDate == yesterday) {
      return 'Yesterday';
    } else {
      return 'Earlier';
    }
  }

  Widget _buildHeader(String title) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      color: Colors.white,
      child: AppText(
        title,
        style: font18w700.copyWith(color: Colors.black),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotificationsCubit, NotificationsState>(
      bloc: _cubit,
      builder: (context, state) {
        if (state is NotificationsLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is NotificationsError) {
          return Center(
            child: AppText(
              state.message,
              style: font14w500.copyWith(color: Colors.red),
            ),
          );
        }
        
        if (state is NotificationsLoaded) {
          if (state.notifications.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.notifications_off_rounded,
                    size: 64.w,
                    color: Colors.grey.shade300,
                  ),
                  SizedBox(height: 16.h),
                  AppText(
                    'No notifications yet',
                    style: font16w600.copyWith(color: Colors.grey.shade600),
                  ),
                ],
              ),
            );
          }
          
          // Group notifications
          final Map<String, List<NotificationEntity>> grouped = {
            'Today': [],
            'Yesterday': [],
            'Earlier': [],
          };
          
          for (var notif in state.notifications) {
            final header = _getSectionHeader(notif.createdAt);
            grouped[header]!.add(notif);
          }
          
          return ListView(
            padding: EdgeInsets.zero,
            children: [
              if (grouped['Today']!.isNotEmpty) ...[
                _buildHeader('Today'),
                ...grouped['Today']!.map((n) => NotificationItemWidget(
                  notification: n,
                  onTap: () {
                    if (!n.isRead) _cubit.markAsRead(n.id);
                  },
                )),
              ],
              if (grouped['Yesterday']!.isNotEmpty) ...[
                _buildHeader('Yesterday'),
                ...grouped['Yesterday']!.map((n) => NotificationItemWidget(
                  notification: n,
                  onTap: () {
                    if (!n.isRead) _cubit.markAsRead(n.id);
                  },
                )),
              ],
              if (grouped['Earlier']!.isNotEmpty) ...[
                _buildHeader('Earlier'),
                ...grouped['Earlier']!.map((n) => NotificationItemWidget(
                  notification: n,
                  onTap: () {
                    if (!n.isRead) _cubit.markAsRead(n.id);
                  },
                )),
              ],
              SizedBox(height: 32.h),
            ],
          );
        }
        
        return const SizedBox.shrink();
      },
    );
  }
}
