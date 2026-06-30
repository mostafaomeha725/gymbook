import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gymbook/core/di/services_locator.dart';
import 'package:gymbook/core/routes/route_paths.dart';
import 'package:gymbook/core/utils/easy_loading.dart';
import 'package:gymbook/core/widgets/switch_open_gym.dart';
import 'package:gymbook/features/auth/domain/usecases/logout_usecase.dart';
import 'package:gymbook/features/notifications/presentation/cubits/notifications_cubit/notifications_cubit.dart';
import 'package:gymbook/features/notifications/presentation/cubits/notifications_cubit/notifications_state.dart';
import 'package:gymbook/features/settings/presentation/widgets/settings_item.dart';

import 'package:gymbook/features/settings/presentation/widgets/notification_status_sheet.dart';

class SettingsCard extends StatelessWidget {
  const SettingsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 12.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15.r,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          const SettingsItem(
            icon: Icons.language,
            title: "Language",
            subtitle: "English",
            showArrow: true,
          ),
          _Divider(),
          BlocConsumer<NotificationsCubit, NotificationsState>(
            listener: (context, state) {
              if (state is NotificationsToggling ||
                  state is NotificationsStatusLoading) {
                showLoading();
              } else {
                hideLoading();
                if (state is NotificationsError) {
                  showError(state.message);
                } else if (state is NotificationsToggled) {
                  NotificationStatusSheet.show(
                    context,
                    isEnabled: state.isEnabled,
                  );
                }
              }
            },
            builder: (context, state) {
              return SettingsItem(
                icon: Icons.notifications_none,
                title: "Notifications",
                subtitle: "Push notifications",
                trailing: OpenGymSwitch(
                  value: context.read<NotificationsCubit>().isEnabled,
                  onChanged: (value) {
                    context.read<NotificationsCubit>().toggleNotifications(
                      value,
                    );
                  },
                ),
              );
            },
          ),
          _Divider(),
          SettingsItem(
            icon: Icons.lock_outline,
            title: "Change Password",
            showArrow: true,
            onTap: () {
              GoRouter.of(context).push(Routes.changePasswordScreen);
            },
          ),
          _Divider(),
          SettingsItem(
            icon: Icons.privacy_tip_outlined,
            title: "Privacy Policy",
            showArrow: true,
            onTap: () {
              GoRouter.of(context).push(Routes.privacyPolicyScreen);
            },
          ),
          _Divider(),
          SettingsItem(
            icon: Icons.description_outlined,
            title: "Terms & Conditions",
            showArrow: true,
            onTap: () {
              GoRouter.of(context).push(Routes.termsOfUseScreen);
            },
          ),
          _Divider(),
          SettingsItem(
            icon: Icons.logout,
            title: "Logout",
            titleColor: Colors.red,
            onTap: () async {
              showLoading();

              await sl<LogoutUseCase>()();

              // Clear notifications cache so a new user won't see old data
              sl<NotificationsCubit>().resetState();

              hideLoading();

              if (context.mounted) {
                GoRouter.of(context).go(Routes.loginScreen);
              }
            },
          ),
        ],
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Divider(height: 1, thickness: 1, color: Colors.grey.shade200);
  }
}
