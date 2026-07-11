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

      case 'scheduled':
        return const Color(0xFFF59E0B);

      case 'cancelled':
        return const Color(0xFF6B7280);

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
  Color getAvatarColor(String? initials) {
    if (initials == 'AM') return const Color(0xFFFFF7ED);
    if (initials == 'SA') return const Color(0xFFF0FDF4);
    if (initials == 'OH') return const Color(0xFFFDF4FF);
    if (initials == 'KS') return const Color(0xFFF0FDF4);
    return Colors.grey.shade100;
  }

  Color getTextColor(String? initials) {
    if (initials == 'AM') return const Color(0xFFEA580C);
    if (initials == 'SA') return const Color(0xFF16A34A);
    if (initials == 'OH') return const Color(0xFF9333EA);
    if (initials == 'KS') return const Color(0xFF16A34A);
    return Colors.black;
  }

  String getSubscriptionStatusText(int statusValue) {
    switch (statusValue) {
      case 0:
        return 'Scheduled';
      case 1:
        return 'Active';
      case 2:
        return 'Frozen';
      case 3:
        return 'Expired';
      case 4:
        return 'Cancelled';
      default:
        return 'Unknown';
    }
  }

  Color getSubscriptionStatusColor(int statusValue) {
    switch (statusValue) {
      case 0:
        return const Color(0xFFF59E0B);
      case 1:
        return Colors.green;
      case 2:
        return Colors.orange;
      case 3:
      case 4:
        return Colors.red;
      default:
        return const Color(0xff64748B);
    }
  }

  Color getSubscriptionStatusBgColor(int statusValue) {
    switch (statusValue) {
      case 0:
        return const Color(0xFFF59E0B).withOpacity(0.15);
      case 1:
        return Colors.green.withOpacity(0.15);
      case 2:
        return Colors.orange.withOpacity(0.15);
      case 3:
      case 4:
        return Colors.red.withOpacity(0.12);
      default:
        return const Color(0xffE2E8F0);
    }
  }
}
