import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MembershipPlanSideArrowButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback onTap;

  const MembershipPlanSideArrowButton({
    super.key,
    required this.icon,
    required this.onTap,
  });

  @override
  State<MembershipPlanSideArrowButton> createState() =>
      _MembershipPlanSideArrowButtonState();
}

class _MembershipPlanSideArrowButtonState
    extends State<MembershipPlanSideArrowButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      scale: _isPressed ? 0.92 : 1.0,
      duration: const Duration(milliseconds: 150),
      curve: Curves.easeInOut,
      child: Container(
        width: 44.w,
        height: 44.w,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: const Color(0xff0EA5E9).withValues(alpha: 0.15),
              blurRadius: 15.r,
              spreadRadius: 2.r,
              offset: const Offset(0, 6),
            ),
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 4.r,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          shape: const CircleBorder(),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: widget.onTap,
            onHighlightChanged: (isHighlighted) {
              setState(() {
                _isPressed = isHighlighted;
              });
            },
            splashColor: const Color(0xff0EA5E9).withValues(alpha: 0.15),
            highlightColor: const Color(0xff0EA5E9).withValues(alpha: 0.05),
            child: Center(
              child: Padding(
                // Add slight padding to perfectly center the iOS chevron icon
                padding: EdgeInsets.only(
                    left: widget.icon == Icons.chevron_right_rounded ? 2.w : 0,
                    right: widget.icon == Icons.chevron_left_rounded ? 2.w : 0),
                child: Icon(
                  widget.icon,
                  color: const Color(0xff0EA5E9),
                  size: 24.sp,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
