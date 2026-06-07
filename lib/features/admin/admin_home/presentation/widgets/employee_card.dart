import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gymbook/features/admin/admin_home/presentation/widgets/employee_card_actions.dart';
import 'package:gymbook/features/admin/admin_home/presentation/widgets/employee_card_avatar.dart';
import 'package:gymbook/features/admin/admin_home/presentation/widgets/employee_card_details.dart';

class EmployeeCard extends StatefulWidget {
  final String name;
  final String role;
  final String phone;
  final String initials;
  final bool? status;
  final VoidCallback? onEdit;
  final ValueChanged<bool>? onToggleStatus;

  const EmployeeCard({
    super.key,
    required this.name,
    required this.role,
    required this.phone,
    required this.initials,
    this.status,
    this.onEdit,
    this.onToggleStatus,
  });

  @override
  State<EmployeeCard> createState() => _EmployeeCardState();
}

class _EmployeeCardState extends State<EmployeeCard> {
  late bool _isActive;

  @override
  void initState() {
    super.initState();
    _isActive = widget.status ?? true;
  }

  @override
  void didUpdateWidget(covariant EmployeeCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.status != oldWidget.status && widget.status != null) {
      _isActive = widget.status!;
    }
  }

  void _toggleStatus(bool value) {
    setState(() {
      _isActive = value;
    });
    widget.onToggleStatus?.call(value);
  }

  @override
  Widget build(BuildContext context) {
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
                color: (widget.status == null || _isActive)
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
                EmployeeCardAvatar(initials: widget.initials),
                SizedBox(width: 12.w),
                Expanded(
                  child: EmployeeCardDetails(
                    name: widget.name,
                    role: widget.role,
                    phone: widget.phone,
                  ),
                ),
                EmployeeCardActions(
                  onEdit: widget.onEdit,
                  hasStatus: widget.status != null,
                  isActive: _isActive,
                  onToggleStatus: _toggleStatus,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
