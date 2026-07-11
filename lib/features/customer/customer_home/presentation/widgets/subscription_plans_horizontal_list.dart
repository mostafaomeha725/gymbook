import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gymbook/core/theme/styles.dart';
import 'package:gymbook/core/widgets/custom_text.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:gymbook/features/customer/customer_home/presentation/widgets/subscription_plan_card.dart';
import 'package:gymbook/features/payments/presentation/cubits/payment_cubit/payment_cubit.dart';
import 'package:gymbook/features/payments/presentation/cubits/payment_cubit/payment_state.dart';

class SubscriptionPlansHorizontalList extends StatelessWidget {
  final int branchId;
  final List<PlanModel> plans;

  const SubscriptionPlansHorizontalList({
    super.key,
    required this.branchId,
    required this.plans,
  });

  @override
  Widget build(BuildContext context) {
    if (plans.isEmpty) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 24.h),
        child: Column(
          children: [
            Icon(
              Icons.card_membership_outlined,
              size: 56.sp,
              color: Colors.grey.shade300,
            ),
            SizedBox(height: 12.h),
            AppText(
              'No Plans Available',
              style: font16w600.copyWith(color: const Color(0xff475569)),
              alignment: AlignmentDirectional.center,
            ),
            SizedBox(height: 12.h),
            AppText(
              'This branch does not have any subscription plans yet.',
              style: font14w400.copyWith(color: const Color(0xff94A3B8)),
              maxLines: 2,
              alignment: AlignmentDirectional.center,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return BlocConsumer<PaymentCubit, PaymentState>(
      listener: (context, state) {
        if (state is PaymentLoading || state is PaymentStatusChecking) {
          EasyLoading.show(
            status: 'Processing Payment...',
            maskType: EasyLoadingMaskType.black,
          );
        } else if (state is PaymentError) {
          EasyLoading.showError(
            state.message,
            duration: const Duration(seconds: 4),
            dismissOnTap: true,
          );
        } else if (state is PaymentStatusSuccess) {
          EasyLoading.showSuccess(
            'Payment Successful!\nSubscription Activated',
            duration: const Duration(seconds: 3),
            dismissOnTap: true,
          );
        } else {
          EasyLoading.dismiss();
        }
      },
      builder: (context, state) {
        return SizedBox(
          height: 275.h,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            itemBuilder: (context, index) {
              return SubscriptionPlanCard(
                plan: plans[index],
                onSubscribe: () {
                  context.read<PaymentCubit>().processPayment(
                    branchId: branchId,
                    packageId: plans[index].id,
                  );
                },
              );
            },
            separatorBuilder: (_, __) => SizedBox(width: 16.w),
            itemCount: plans.length,
          ),
        );
      },
    );
  }
}
