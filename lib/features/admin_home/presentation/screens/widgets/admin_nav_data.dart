import 'package:flutter/material.dart';
import 'package:gymbook/features/admin_home/presentation/screens/admin_branch_screen.dart';
import 'package:gymbook/features/admin_home/presentation/screens/admin_home_screen.dart';
import 'package:gymbook/features/home/presentation/screens/settings_screen.dart';

class AdminNavData {
  static final List<Map<String, dynamic>> items = [
    {'label': 'Home', 'icon': Icons.home_rounded},
    {'label': 'Branches', 'icon': Icons.store_rounded},
    {'label': 'Performance', 'icon': Icons.bar_chart_rounded},
    {'label': 'Settings', 'icon': Icons.settings_rounded},
  ];

  static const List<Widget> screens = [
    AdminHomeScreen(),
    AdminBranchScreen(),
    AdminHomeScreen(),
    SettingsScreen(),
  ];
}
