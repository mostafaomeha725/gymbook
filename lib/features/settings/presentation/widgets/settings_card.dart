import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:gymbook/core/routes/route_paths.dart';
import 'package:gymbook/core/widgets/switch_open_gym.dart';
import 'package:gymbook/features/settings/presentation/widgets/settings_item.dart';

class SettingsCard extends StatefulWidget {
  const SettingsCard({super.key});

  @override
  State<SettingsCard> createState() => SettingsCardState();
}

class SettingsCardState extends State<SettingsCard> {
  bool isNotificationEnabled = true;

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
              onChanged: (bool value) {
                setState(() {
                  isNotificationEnabled = value;
                });
              },
            ),
          ),

          _Divider(),

          const SettingsItem(
            icon: Icons.help_outline,
            title: "Help & Support",
            showArrow: true,
          ),
          _Divider(),

          const SettingsItem(
            icon: Icons.description_outlined,
            title: "Terms & Conditions",
            showArrow: true,
          ),
          _Divider(),

          SettingsItem(
            icon: Icons.logout,
            title: "Logout",
            titleColor: Colors.red,
            onTap: () {
              GoRouter.of(context).pushReplacement(Routes.loginScreen);
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
