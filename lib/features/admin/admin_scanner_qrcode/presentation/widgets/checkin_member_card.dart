import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gymbook/features/admin/admin_scanner_qrcode/data/models/checkin_result_model.dart';
import 'package:gymbook/features/admin/admin_scanner_qrcode/presentation/widgets/checkin_info_row.dart';
import 'package:intl/intl.dart';

class CheckInMemberCard extends StatelessWidget {
  final CheckInResultModel result;

  const CheckInMemberCard({super.key, required this.result});

  String _formatDate(String raw) {
    if (raw.isEmpty) return '--';
    try {
      final dt = DateTime.parse(raw).toLocal();
      return DateFormat('MMM d, yyyy  •  h:mm a').format(dt);
    } catch (_) {
      return raw;
    }
  }

  @override
  Widget build(BuildContext context) {
    final formattedDate = _formatDate(result.lastCheckIn);
    final initials = result.memberName.isNotEmpty
        ? result.memberName
              .trim()
              .split(' ')
              .take(2)
              .map((w) => w.isNotEmpty ? w[0].toUpperCase() : '')
              .join()
        : '?';

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w),
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: const Color(0xffF8FAFC),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: const Color(0xffE2E8F0)),
      ),
      child: Column(
        children: [
          // Avatar + name row
          Row(
            children: [
              // Avatar circle
              Container(
                width: 52.w,
                height: 52.w,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xff0EA5E9), Color(0xff0284C7)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    initials,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 18.sp,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 14.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      result.memberName.isNotEmpty
                          ? result.memberName
                          : 'Member',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xff0F172A),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 3.h),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 3.h,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xffDCFCE7),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Text(
                        'Active Member',
                        style: TextStyle(
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xff16A34A),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: 16.h),

          const Divider(color: Color(0xffE2E8F0), height: 1),

          SizedBox(height: 16.h),

          // Info rows
          CheckInInfoRow(
            icon: Icons.card_membership_outlined,
            label: 'Package',
            value: result.packageName.isNotEmpty ? result.packageName : '--',
            iconColor: const Color(0xff8B5CF6),
          ),
          SizedBox(height: 12.h),
          CheckInInfoRow(
            icon: Icons.access_time_rounded,
            label: 'Last Check-In',
            value: formattedDate,
            iconColor: const Color(0xff0EA5E9),
          ),
        ],
      ),
    );
  }
}
