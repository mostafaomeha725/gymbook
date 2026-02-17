import 'package:flutter/material.dart';

class GetTypeColor {
  Color getTypeColor(String type) {
    final value = type.toLowerCase().trim();

    switch (value) {
      /// 🔹 Gym Types
      case 'mixed':
        return const Color(0xFF8B5CF6);

      case 'male':
        return const Color(0xFF3B82F6);

      case 'female':
        return const Color(0xFFEC4899);

      /// 🔹 Status Old
      case 'active':
      case 'open':
      case 'open now':
        return const Color(0xFF4CAF50);

      case 'closed':
        return const Color(0xFF991B1B);

      /// 🔹 Subscription Status New
      case 'available':
        return const Color(0xFF16A34A); // أخضر

      case 'expired':
        return const Color(0xFFEF4444); // أحمر

      case 'freezed':
      case 'frozen':
        return const Color(0xFF2563EB); // أزرق

      default:
        return Colors.grey;
    }
  }

  /// ================= Badge Background =================
  Color getBgColor(String type) {
    return getTypeColor(type).withOpacity(0.15);
  }

  /// ================= Card Gradient =================
  LinearGradient getCardGradient(String type) {
    final color = getTypeColor(type);

    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [color, color.withOpacity(.85)],
    );
  }

  /// ================= Progress Bar Color =================
  Color getProgressColor(String type) {
    return getTypeColor(type);
  }

  /// ================= Card Border =================
  Color getBorderColor(String type) {
    return getTypeColor(type).withOpacity(.35);
  }

  /// ================= Text Color On Card =================
  Color getOnCardTextColor(String type) {
    final value = type.toLowerCase().trim();

    if (value == 'expired') {
      return Colors.white;
    }

    return Colors.white;
  }

  /// ================= Light Circle Decoration =================
  Color getCircleOverlayColor(String type) {
    return Colors.white.withOpacity(.15);
  }
}
