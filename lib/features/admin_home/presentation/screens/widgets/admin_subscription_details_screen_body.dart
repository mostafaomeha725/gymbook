import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gymbook/core/widgets/appbar_subscription_widget.dart';
import 'package:gymbook/features/admin_home/presentation/screens/widgets/admin_subscription_details_card.dart';
import 'package:gymbook/features/admin_home/presentation/screens/widgets/branch_buttom.dart';
import 'package:gymbook/features/admin_home/presentation/screens/widgets/customer_details_card.dart';
import 'package:gymbook/features/admin_home/presentation/screens/widgets/freeze_information_card.dart';
import 'package:gymbook/features/admin_home/presentation/screens/widgets/status_card.dart';

class AdminSubscriptionDetailsScreenBody extends StatelessWidget {
  const AdminSubscriptionDetailsScreenBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
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
          BranchButtom(
            text: 'Cancel Subscription',
            icon: Icons.close,
            gradient: const LinearGradient(
              colors: [Color(0xFFEF4444), Color(0xFFDC2626)],
            ),
            iconGradient: const LinearGradient(
              colors: [Color(0xFFF87171), Color(0xFFEF4444)],
            ),
            onTap: () {},
          ),
          SizedBox(height: 40.h),
        ],
      ),
    );
  }
}
