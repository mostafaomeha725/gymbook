import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gymbook/core/theme/styles.dart';
import 'package:gymbook/core/widgets/custom_text.dart';
import 'package:gymbook/features/admin/admin_home/presentation/cubits/branch_details_cubit/branch_details_cubit.dart';
import 'package:gymbook/features/admin/admin_home/presentation/widgets/status_card.dart';

class AllCurrentStatus extends StatelessWidget {
  const AllCurrentStatus({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BranchDetailsCubit, BranchDetailsState>(
      builder: (context, state) {
        final details = state is BranchDetailsSuccess ? state.response : null;

        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 22.w),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: AppText(
                  'Current Status',
                  style: font20w700.copyWith(color: const Color(0xff2C3E50)),
                ),
              ),

              SizedBox(height: 16.h),

              Row(
                children: [
                  Expanded(
                    child: StatusCard(
                      icon: Icons.person_outline,
                      title:
                          details?.activeSubscriptionsCount.toString() ?? '-',
                      subtitle: 'Subscriptions',
                      iconColor: const Color(0xFF0EA5E9),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: StatusCard(
                      icon: Icons.inventory_2_outlined,
                      title: details?.activePackagesCount.toString() ?? '-',
                      subtitle: 'Packages',
                      iconColor: const Color(0xFFF59E0B),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: StatusCard(
                      icon: Icons.meeting_room_outlined,
                      title: details != null
                          ? (details.isOpenNow ? 'Open' : 'Closed')
                          : '-',
                      subtitle: 'Status',
                      iconColor: details?.isOpenNow == true
                          ? const Color(0xFF10B981)
                          : Colors.red,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
