import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:gymbook/core/routes/route_paths.dart';
import 'package:gymbook/core/di/services_locator.dart';
import 'package:gymbook/features/notifications/presentation/cubits/notifications_cubit/notifications_cubit.dart';
import 'package:gymbook/features/notifications/presentation/cubits/notifications_cubit/notifications_state.dart';
import 'package:gymbook/core/widgets/custom_text.dart';
import 'package:gymbook/core/theme/styles.dart';

class NotificationIcon extends StatelessWidget {
  const NotificationIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push(Routes.notificationsScreen),
      child: BlocBuilder<NotificationsCubit, NotificationsState>(
        bloc: sl<NotificationsCubit>(),
        builder: (context, state) {
          int badgeCount = 0;
          if (state is NotificationsLoaded) {
            badgeCount = state.badgeCount;
          }

          return Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  // ignore: deprecated_member_use
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.notifications_none_rounded,
                  color: Colors.white,
                  size: 26.sp,
                ),
              ),
              if (badgeCount > 0)
                Positioned(
                  right: -2.w,
                  top: -2.h,
                  child: Container(
                    padding: EdgeInsets.all(4.w),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 1.5),
                    ),
                    child: AppText(
                      badgeCount > 9 ? '+9' : badgeCount.toString(),
                      style: font12w700.copyWith(
                        color: Colors.white,
                        fontSize: 10.sp,
                        height: 1.0,
                      ),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
