import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gymbook/core/widgets/appbar_subscription_widget.dart';
import 'package:gymbook/features/admin_home/domain/entities/subscription_details_entity.dart';
import 'package:gymbook/features/admin_home/domain/entities/subscription_item_entity.dart';
import 'package:gymbook/features/admin_home/presentation/cubits/cancel_subscription_cubit/cancel_subscription_cubit.dart';
import 'package:gymbook/features/admin_home/presentation/cubits/cancel_subscription_cubit/cancel_subscription_state.dart';
import 'package:gymbook/features/admin_home/presentation/cubits/freeze_subscription_cubit/freeze_subscription_cubit.dart';
import 'package:gymbook/features/admin_home/presentation/cubits/freeze_subscription_cubit/freeze_subscription_state.dart';
import 'package:gymbook/features/admin_home/presentation/widgets/admin_subscription_details_card.dart';
import 'package:gymbook/features/admin_home/presentation/widgets/branch_buttom.dart';
import 'package:gymbook/features/admin_home/presentation/widgets/customer_details_card.dart';
import 'package:gymbook/features/admin_home/presentation/widgets/freeze_information_card.dart';
import 'package:gymbook/features/admin_home/presentation/widgets/status_card.dart';

class DetailsContent extends StatelessWidget {
  final SubscriptionDetailsEntity details;
  const DetailsContent({super.key, required this.details});

  String _formatDate(DateTime dt) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${dt.day} ${months[dt.month - 1]}';
  }

  @override
  Widget build(BuildContext context) {
    final status = SubscriptionStatus.fromInt(details.status);
    final statusLabel = status.displayName;
    final shouldFreeze = status != SubscriptionStatus.frozen;

    return SingleChildScrollView(
      child: Column(
        children: [
          const AppbarSubscriptionWidget(text: 'Subscription Details'),
          SizedBox(height: 24.h),
          AdminSubscriptionDetailsCard(
            name: details.member.fullName,
            plan: details.packageName,
            price: details.paidAmount.toStringAsFixed(0),
            status: statusLabel,
            remaining: details.remainingDays,
            total: details.totalDays,
          ),
          SizedBox(height: 24.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 22.w),
            child: Row(
              children: [
                Expanded(
                  child: StatusCard(
                    icon: Icons.calendar_today_outlined,
                    title: _formatDate(details.activationDate),
                    subtitle: "Started",
                    iconColor: const Color(0xFF0EA5E9),
                    isCenter: true,
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: StatusCard(
                    icon: Icons.access_time_outlined,
                    title: "${details.durationInMonths} months",
                    subtitle: "Duration",
                    iconColor: const Color(0xFF0EA5E9),
                    isCenter: true,
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: StatusCard(
                    icon: Icons.event_available_outlined,
                    title: _formatDate(details.expirationDate),
                    subtitle: "Ends On",
                    iconColor: const Color(0xFF0EA5E9),
                    isCenter: true,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 24.h),
          CustomerDetailsCard(
            name: details.member.fullName,
            email: details.member.email,
            phone: details.member.phoneNumber,
          ),
          SizedBox(height: 12.h),
          FreezeInformationCard(freezes: details.remainingFreezesCount),
          SizedBox(height: 12.h),
          BlocBuilder<FreezeSubscriptionCubit, FreezeSubscriptionState>(
            builder: (context, state) {
              final isLoading = state is FreezeSubscriptionLoading;

              return BranchButtom(
                text: isLoading
                    ? 'Processing...'
                    : shouldFreeze
                    ? 'Freeze Subscription'
                    : 'Un Freeze Subscription',
                icon: Icons.ac_unit,
                gradient: const LinearGradient(
                  colors: [Color(0xFFF59E0B), Color(0xFFD97706)],
                ),
                iconGradient: const LinearGradient(
                  colors: [Color(0xFFFBBF24), Color(0xFFF59E0B)],
                ),
                onTap: isLoading
                    ? () {}
                    : () => context.read<FreezeSubscriptionCubit>().submit(
                        subscriptionId: details.subscriptionId,
                        shouldFreeze: shouldFreeze,
                      ),
              );
            },
          ),
          SizedBox(height: 12.h),

          // ── Cancel Subscription button ──────────────────────────────
          BlocBuilder<CancelSubscriptionCubit, CancelSubscriptionState>(
            builder: (context, state) {
              final isLoading = state is CancelSubscriptionLoading;
              return BranchButtom(
                text: isLoading ? 'Cancelling...' : 'Cancel Subscription',
                icon: Icons.close,
                gradient: const LinearGradient(
                  colors: [Color(0xFFEF4444), Color(0xFFDC2626)],
                ),
                iconGradient: const LinearGradient(
                  colors: [Color(0xFFF87171), Color(0xFFEF4444)],
                ),
                onTap: isLoading
                    ? () {}
                    : () => context
                          .read<CancelSubscriptionCubit>()
                          .cancelSubscription(
                            subscriptionId: details.subscriptionId,
                          ),
              );
            },
          ),
          SizedBox(height: 40.h),
        ],
      ),
    );
  }
}
