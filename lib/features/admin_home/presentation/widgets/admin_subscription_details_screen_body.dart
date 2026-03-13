import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:gymbook/core/di/services_locator.dart';
import 'package:gymbook/core/widgets/appbar_subscription_widget.dart';
import 'package:gymbook/features/admin_home/domain/entities/subscription_details_entity.dart';
import 'package:gymbook/features/admin_home/domain/entities/subscription_item_entity.dart';
import 'package:gymbook/features/admin_home/presentation/cubits/cancel_subscription_cubit/cancel_subscription_cubit.dart';
import 'package:gymbook/features/admin_home/presentation/cubits/cancel_subscription_cubit/cancel_subscription_state.dart';
import 'package:gymbook/features/admin_home/presentation/cubits/subscription_details_cubit/subscription_details_cubit.dart';
import 'package:gymbook/features/admin_home/presentation/cubits/subscription_details_cubit/subscription_details_state.dart';
import 'package:gymbook/features/admin_home/presentation/widgets/admin_subscription_details_card.dart';
import 'package:gymbook/features/admin_home/presentation/widgets/branch_buttom.dart';
import 'package:gymbook/features/admin_home/presentation/widgets/customer_details_card.dart';
import 'package:gymbook/features/admin_home/presentation/widgets/freeze_information_card.dart';
import 'package:gymbook/features/admin_home/presentation/widgets/status_card.dart';

class AdminSubscriptionDetailsScreenBody extends StatelessWidget {
  final int subscriptionId;
  const AdminSubscriptionDetailsScreenBody({
    super.key,
    required this.subscriptionId,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) =>
              sl<SubscriptionDetailsCubit>()..loadDetails(subscriptionId),
        ),
        BlocProvider(create: (_) => sl<CancelSubscriptionCubit>()),
      ],
      child: BlocListener<CancelSubscriptionCubit, CancelSubscriptionState>(
        listener: (context, state) {
          if (state is CancelSubscriptionSuccess) {
            GoRouter.of(context).pop(true);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Subscription cancelled successfully'),
                backgroundColor: Colors.green,
              ),
            );
          } else if (state is CancelSubscriptionFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: BlocBuilder<SubscriptionDetailsCubit, SubscriptionDetailsState>(
          builder: (context, state) {
            if (state is SubscriptionDetailsLoading ||
                state is SubscriptionDetailsInitial) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is SubscriptionDetailsFailure) {
              return Center(
                child: Text(
                  state.message,
                  style: const TextStyle(color: Colors.red),
                ),
              );
            }
            if (state is SubscriptionDetailsSuccess) {
              return _DetailsContent(details: state.details);
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}

class _DetailsContent extends StatelessWidget {
  final SubscriptionDetailsEntity details;
  const _DetailsContent({required this.details});

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
    final statusLabel = SubscriptionStatus.fromInt(details.status).displayName;

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
          BranchButtom(
            text: 'Freeze Subscription',
            icon: Icons.ac_unit,
            gradient: const LinearGradient(
              colors: [Color(0xFFF59E0B), Color(0xFFD97706)],
            ),
            iconGradient: const LinearGradient(
              colors: [Color(0xFFFBBF24), Color(0xFFF59E0B)],
            ),
            onTap: () {},
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
