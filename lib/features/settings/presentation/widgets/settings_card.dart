import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:gymbook/core/di/services_locator.dart';
import 'package:gymbook/core/routes/route_paths.dart';
import 'package:gymbook/core/utils/easy_loading.dart';
import 'package:gymbook/core/widgets/switch_open_gym.dart';
import 'package:gymbook/features/auth/domain/usecases/logout_usecase.dart';
import 'package:gymbook/features/notifications/domain/usecases/update_fcm_token_usecase.dart';
import 'package:gymbook/features/notifications/presentation/cubits/notifications_cubit/notifications_cubit.dart';
import 'package:gymbook/features/settings/presentation/widgets/settings_item.dart';

class SettingsCard extends StatefulWidget {
  const SettingsCard({super.key});

  @override
  State<SettingsCard> createState() => SettingsCardState();
}

class SettingsCardState extends State<SettingsCard> {
  bool isNotificationEnabled = false;

  @override
  void initState() {
    super.initState();
    _checkNotificationStatus();
  }

  Future<void> _checkNotificationStatus() async {
    final settings = await FirebaseMessaging.instance.getNotificationSettings();
    setState(() {
      isNotificationEnabled =
          settings.authorizationStatus == AuthorizationStatus.authorized ||
          settings.authorizationStatus == AuthorizationStatus.provisional;
    });
  }

  Future<void> _toggleNotifications(bool value) async {
    if (value) {
      final settings = await FirebaseMessaging.instance.requestPermission();
      if (settings.authorizationStatus == AuthorizationStatus.authorized ||
          settings.authorizationStatus == AuthorizationStatus.provisional) {
        setState(() {
          isNotificationEnabled = true;
        });
        // This gets the token and sends it to the backend
        await sl<NotificationsCubit>().initNotifications();
      } else {
        // User denied or it's permanently denied from OS
        showError('Please enable notifications from device settings');
        setState(() {
          isNotificationEnabled = false;
        });
      }
    } else {
      // User disabled notifications from within the app
      try {
        await FirebaseMessaging.instance.deleteToken();
        await sl<UpdateFcmTokenUseCase>()(""); // clear from backend
      } catch (e) {
        debugPrint(e.toString());
      }
      setState(() {
        isNotificationEnabled = false;
      });
    }
  }

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
          SettingsItem(
            icon: Icons.notifications_none,
            title: "Notifications",
            subtitle: "Push notifications",
            trailing: OpenGymSwitch(
              value: isNotificationEnabled,
              onChanged: _toggleNotifications,
            ),
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
