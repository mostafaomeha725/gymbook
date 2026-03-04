import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:gymbook/core/di/services_locator.dart';
import 'package:gymbook/core/widgets/appbar_subscription_widget.dart';
import 'package:gymbook/features/admin_home/presentation/cubits/cancel_subscription_cubit/cancel_subscription_cubit.dart';
import 'package:gymbook/features/admin_home/presentation/cubits/cancel_subscription_cubit/cancel_subscription_state.dart';
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
    return BlocProvider(
      create: (_) => sl<CancelSubscriptionCubit>(),
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
            // Optionally, navigate back or refresh the data
          } else if (state is CancelSubscriptionFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: SingleChildScrollView(
          child: Column(
            children: [
              const AppbarSubscriptionWidget(text: 'Subscription Details'),
              SizedBox(height: 24.h),
              const AdminSubscriptionDetailsCard(
                name: "Ahmed Hassan",
                plan: "Basic Monthly",
                price: "500",
                status: "Available",
                remaining: 15,
                total: 30,
              ),
              SizedBox(height: 24.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 22.w),
                child: Row(
                  children: [
                    const Expanded(
                      child: StatusCard(
                        icon: Icons.calendar_today_outlined,
                        title: "15 Jan",
                        subtitle: "Started",
                        iconColor: Color(0xFF0EA5E9),
                        isCenter: true,
                      ),
                    ),
                    SizedBox(width: 12.w),
                    const Expanded(
                      child: StatusCard(
                        icon: Icons.access_time_outlined,
                        title: "30 days",
                        subtitle: "Duration",
                        iconColor: Color(0xFF0EA5E9),
                        isCenter: true,
                      ),
                    ),
                    SizedBox(width: 12.w),
                    const Expanded(
                      child: StatusCard(
                        icon: Icons.event_available_outlined,
                        title: "14 Feb",
                        subtitle: "Ends On",
                        iconColor: Color(0xFF0EA5E9),
                        isCenter: true,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24.h),
              const CustomerDetailsCard(
                name: "Ahmed Hassan",
                email: "ahmed.hassan@email.com",
                phone: "+20 100 123 4567",
              ),
              SizedBox(height: 12.h),
              const FreezeInformationCard(freezes: 1),
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

              // ── Cancel Subscription button ──────────────────────────
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
                                subscriptionId: subscriptionId,
                              ),
                  );
                },
              ),
              SizedBox(height: 40.h),
            ],
          ),
        ),
      ),
    );
  }
}
