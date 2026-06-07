import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gymbook/features/admin/admin_home/presentation/widgets/employee_card_actions.dart';
import 'package:gymbook/features/admin/admin_home/presentation/widgets/employee_card_avatar.dart';
import 'package:gymbook/features/admin/admin_home/presentation/widgets/employee_card_details.dart';

class EmployeeCard extends StatelessWidget {
  final String name;
  final String role;
  final String phone;
  final String initials;
  final bool? status;
  final VoidCallback? onEdit;

  const EmployeeCard({
    super.key,
    required this.name,
    required this.role,
    required this.phone,
    required this.initials,
    this.status,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final isActive = status ?? true;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Left border indicator
          Positioned(
            left: 0,
            top: 0,
            bottom: 0,
            child: Container(
              width: 4.w,
              decoration: BoxDecoration(
                color: isActive
                    ? const Color(0xFF10B981)
                    : const Color(0xFFEF4444),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16.r),
                  bottomLeft: Radius.circular(16.r),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                EmployeeCardAvatar(initials: initials),
                SizedBox(width: 12.w),
                Expanded(
                  child: EmployeeCardDetails(
                    name: name,
                    role: role,
                    phone: phone,
                  ),
                ),
                EmployeeCardActions(
                  onEdit: onEdit,
                  hasStatus: status != null,
                  isActive: isActive,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
