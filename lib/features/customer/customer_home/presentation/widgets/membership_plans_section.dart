import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gymbook/core/theme/styles.dart';
import 'package:gymbook/core/widgets/custom_text.dart';
import 'package:gymbook/features/customer/customer_home/presentation/cubits/public_branch_packages_cubit/public_branch_packages_cubit.dart';
import 'package:gymbook/features/customer/customer_home/presentation/cubits/public_branch_packages_cubit/public_branch_packages_state.dart';
import 'package:gymbook/features/customer/customer_home/presentation/widgets/membership_plan_card.dart';
import 'package:gymbook/features/customer/customer_home/presentation/widgets/membership_plan_pagination.dart';

class MembershipPlansSection extends StatelessWidget {
  final int branchId;

  const MembershipPlansSection({super.key, required this.branchId});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PublicBranchPackagesCubit, PublicBranchPackagesState>(
      builder: (context, state) {
        if (state is PublicBranchPackagesLoading) {
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 40.h),
            child: const Center(child: CircularProgressIndicator()),
          );
        }

        if (state is PublicBranchPackagesFailure) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
            child: AppText(
              state.message,
              style: font14w400.copyWith(color: const Color(0xff94A3B8)),
              alignment: AlignmentDirectional.center,
            ),
          );
        }

        if (state is! PublicBranchPackagesLoaded) {
          return const SizedBox.shrink();
        }

        final response = state.response;

        if (response.totalCount == 0 || response.data.isEmpty) {
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 24.h),
            child: AppText(
              'No plans available for this branch',
              style: font14w400.copyWith(color: const Color(0xff94A3B8)),
              alignment: AlignmentDirectional.center,
            ),
          );
        }

        final packages = response.data;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 275.h,
              child: ListView.separated(
                key: ValueKey(response.currentPage),
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                itemBuilder: (context, index) {
                  return MembershipPlanCard(
                    package: packages[index],
                    branchId: branchId,
                  );
                },
                separatorBuilder: (_, __) => SizedBox(width: 16.w),
                itemCount: packages.length,
              ),
            ),
            if (response.totalPages > 1)
              MembershipPlanPagination(
                currentPage: response.currentPage,
                totalPages: response.totalPages,
                totalCount: response.totalCount,
                onPageChanged: (page) =>
                    context.read<PublicBranchPackagesCubit>().changePage(page),
              ),
          ],
        );
      },
    );
  }
}
