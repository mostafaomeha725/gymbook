import 'package:flutter/material.dart';
import 'package:gymbook/features/home/presentation/screens/customer_home_screen.dart';
import 'package:gymbook/features/home/presentation/screens/entry_qrcode_gym_screen.dart';
import 'package:gymbook/features/home/presentation/screens/settings_screen.dart';
import 'package:gymbook/features/home/presentation/screens/subscriptions_screen.dart';

class CustomerNavData {
  static final List<Map<String, dynamic>> items = [
    {'label': 'Home', 'icon': Icons.home_rounded},
    {'label': 'Subscriptions', 'icon': Icons.card_membership_rounded},
    {'label': 'QR Code', 'icon': Icons.qr_code_scanner_rounded},
    {'label': 'Settings', 'icon': Icons.settings_rounded},
  ];

  static const List<Widget> screens = [
    CustomerHomeScreen(),
    SubscriptionsScreen(),
    EntryQrcodeGymScreen(),
    SettingsScreen(),
  ];
}
