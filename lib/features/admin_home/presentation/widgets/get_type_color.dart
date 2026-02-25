import 'package:flutter/material.dart';

class GetTypeColor {
  Color getTypeColor(String type) {
    final value = type.toLowerCase().trim();

    switch (value) {
      /// 🔹 Gym Types Old
      case 'mixed':
        return const Color(0xFF8B5CF6);

      case 'male':
        return const Color(0xFF3B82F6);

      case 'female':
        return const Color(0xFFEC4899);

      /// 🔹 Gym Types New (من الـ Backend Enum)
      case 'male only':
        return const Color(0xFF3B82F6);

      case 'female only':
        return const Color(0xFFEC4899);

      case 'mixed gym':
        return const Color(0xFF8B5CF6);

      /// 🔹 Status Old
      case 'active':
      case 'open':
      case 'open now':
        return const Color(0xFF4CAF50);

      case 'closed':
        return const Color(0xFF991B1B);

      /// 🔹 Status New (Branch Status Enum)
      case 'Draft':
        return const Color(0xFF6B7280); // رمادي

      case 'inactive':
        return const Color(0xFF9CA3AF); // رمادي فاتح

      case 'closedbranch':
        return const Color(0xFF991B1B);

      /// 🔹 Subscription Status New
      case 'available':
        return const Color(0xFF16A34A);

      case 'expired':
        return const Color(0xFFEF4444);

      case 'freezed':
      case 'frozen':
        return const Color(0xFF2563EB);

      default:
        return Colors.grey;
    }
  }

  Color getBgColor(String type) => getTypeColor(type).withOpacity(0.15);

  LinearGradient getCardGradient(String type) {
    final color = getTypeColor(type);
    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [color, color.withOpacity(.85)],
    );
  }

  Color getProgressColor(String type) => getTypeColor(type);

  Color getBorderColor(String type) => getTypeColor(type).withOpacity(.35);

  Color getOnCardTextColor(String type) => Colors.white;

  Color getCircleOverlayColor(String type) => Colors.white.withOpacity(.15);
}
