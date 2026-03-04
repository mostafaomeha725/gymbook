import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gymbook/core/theme/styles.dart';
import 'package:gymbook/core/widgets/custom_text.dart';
import 'package:gymbook/features/admin_home/domain/entities/package_entity.dart';
import 'package:gymbook/features/admin_home/presentation/cubits/branch_packages_list_cubit/branch_packages_list_cubit.dart';
import 'package:gymbook/features/admin_home/presentation/widgets/package_select_card.dart';
import 'package:gymbook/features/admin_home/presentation/widgets/subscription_summary_card.dart';

class PackagesListSection extends StatelessWidget {
  final int? selectedPackageIndex;
  final ValueChanged<int> onPackageSelected;

  const PackagesListSection({
    super.key,
    required this.selectedPackageIndex,
    required this.onPackageSelected,
  });

  String _formatDuration(int months) => months == 1 ? '1m' : '${months}m';

  String _formatPrice(double value) {
    final hasFraction = value % 1 != 0;
    return hasFraction ? value.toStringAsFixed(2) : value.toStringAsFixed(0);
  }

  List<PackageEntity> _activePackages(BranchPackagesListState state) {
    if (state is BranchPackagesListSuccess) {
      return state.response.data.where((p) => p.isActive).toList();
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BranchPackagesListCubit, BranchPackagesListState>(
      builder: (context, state) {
        // ── Loading ──────────────────────────────────────────────────
        if (state is BranchPackagesListLoading) {
          return Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 32.h),
              child: const CircularProgressIndicator.adaptive(),
            ),
          );
        }

        // ── Failure ──────────────────────────────────────────────────
        if (state is BranchPackagesListFailure) {
          return Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 24.h),
              child: AppText(
                state.message,
                style: font14w500.copyWith(color: Colors.red),
              ),
            ),
          );
        }

        final packages = _activePackages(state);

        // ── Empty ────────────────────────────────────────────────────
        if (packages.isEmpty && state is BranchPackagesListSuccess) {
          return Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 32.h),
              child: AppText(
                'No active packages available',
                style: font14w500.copyWith(color: Colors.grey.shade500),
              ),
            ),
          );
        }

        // ── List ─────────────────────────────────────────────────────
        return Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 22.w),
              child: Column(
                children: List.generate(packages.length, (index) {
                  final pkg = packages[index];
                  return Padding(
                    padding: EdgeInsets.only(bottom: 12.h),
                    child: PackageSelectCard(
                      title: pkg.name,
                      duration: _formatDuration(pkg.durationInMonths),
                      price: _formatPrice(pkg.price),
                      freezes: '${pkg.numberOfFreezes}',
                      icon: Icons.inventory_2_outlined,
                      isActive: selectedPackageIndex == index,
                      onTap: () => onPackageSelected(index),
                    ),
                  );
                }),
              ),
            ),

            // ── Summary card ─────────────────────────────────────────
            if (selectedPackageIndex != null &&
                selectedPackageIndex! < packages.length) ...[
              SizedBox(height: 4.h),
              SubscriptionSummaryCard(
                planName: packages[selectedPackageIndex!].name,
                price: _formatPrice(packages[selectedPackageIndex!].price),
              ),
              SizedBox(height: 12.h),
            ],
          ],
        );
      },
    );
  }
}
