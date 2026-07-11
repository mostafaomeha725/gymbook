import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gymbook/features/admin/admin_scanner_qrcode/data/models/checkin_result_model.dart';
import 'package:gymbook/features/admin/admin_scanner_qrcode/presentation/widgets/checkin_member_card.dart';
import 'package:gymbook/features/admin/admin_scanner_qrcode/presentation/widgets/checkin_success_icon.dart';

class CheckInSuccessSheet extends StatelessWidget {
  final CheckInResultModel result;
  final VoidCallback onDismiss;

  const CheckInSuccessSheet({
    super.key,
    required this.result,
    required this.onDismiss,
  });

  static Future<void> show(
    BuildContext context, {
    required CheckInResultModel result,
    required VoidCallback onDismiss,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.6),
      useSafeArea: true,
      builder: (_) => CheckInSuccessSheet(result: result, onDismiss: onDismiss),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28.r),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── Drag Handle ──────────────────────────────────────
          SizedBox(height: 12.h),
          Container(
            width: 40.w,
            height: 4.h,
            decoration: BoxDecoration(
              color: const Color(0xffE2E8F0),
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),
          SizedBox(height: 28.h),

          const CheckInSuccessIcon(),
          SizedBox(height: 16.h),

          Text(
            'Check-in Successful!',
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.w700,
              color: const Color(0xff0F172A),
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            'Member has been checked in',
            style: TextStyle(fontSize: 13.sp, color: const Color(0xff64748B)),
          ),

          SizedBox(height: 28.h),

          CheckInMemberCard(result: result),

          SizedBox(height: 24.h),

          // ── Done button ──────────────────────────────────────
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
                onDismiss();
              },
              child: Container(
                height: 52.h,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xff10B981), Color(0xff059669)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16.r),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xff10B981).withValues(alpha: 0.35),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    'Done',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 28.h),
        ],
      ),
    );
  }
}
