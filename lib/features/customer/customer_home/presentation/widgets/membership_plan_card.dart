import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gymbook/core/theme/styles.dart';
import 'package:gymbook/core/widgets/custom_button.dart';
import 'package:gymbook/core/widgets/custom_text.dart';
import 'package:gymbook/features/customer/customer_home/data/models/public_branch_package_model.dart';
import 'package:gymbook/features/payments/presentation/cubits/payment_cubit/payment_cubit.dart';
import 'package:gymbook/features/payments/presentation/cubits/payment_cubit/payment_state.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class MembershipPlanCard extends StatelessWidget {
  final PublicBranchPackageModel package;
  final int branchId;

  const MembershipPlanCard({
    super.key,
    required this.package,
    required this.branchId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocListener<PaymentCubit, PaymentState>(
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
      child: Container(
        width: 240.w,
        padding: EdgeInsets.all(24.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24.r),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xff0EA5E9), Color(0xff0284C7)],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            AppText(
              package.name,
              style: font18w700.copyWith(color: Colors.white, height: 1.2),
              maxLines: 2,
            ),
            SizedBox(height: 12.h),
            AppText(
              '${package.price.toInt()} EGP',
              style: font32w700.copyWith(color: Colors.white),
            ),
            SizedBox(height: 4.h),
            AppText(
              '${package.durationInMonths} month${package.durationInMonths == 1 ? '' : 's'}',
              style: font14w400.copyWith(
                color: Colors.white.withValues(alpha: 0.9),
              ),
            ),
            SizedBox(height: 16.h),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Row(
                children: [
                  Icon(Icons.ac_unit_rounded, color: Colors.white, size: 18.sp),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: AppText(
                      '${package.numberOfFreezes} Freezes (${package.freezeDurationInDays} Days)',
                      style: font12w500.copyWith(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16.h),
            const Spacer(),
            AppButton(
              text: 'Subscribe',
              onPressed: () {
                print(
                  '🚀 ATTEMPTING TO SUBSCRIBE TO PACKAGE: ${package.id} FOR BRANCH: $branchId',
                );
                context.read<PaymentCubit>().processPayment(
                  branchId: branchId,
                  packageId: package.id,
                );
              },
              color: Colors.white,
              textColor: const Color(0xff0EA5E9),
            ),
          ],
        ),
      ),
    );
  }
}
