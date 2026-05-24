import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:gymbook/core/routes/route_paths.dart';
import 'package:gymbook/core/theme/styles.dart';
import 'package:gymbook/core/widgets/appbar_subscription_widget.dart';
import 'package:gymbook/core/widgets/custom_text.dart';
import 'package:gymbook/features/admin/admin_home/data/models/package_model.dart';
import 'package:gymbook/features/admin/admin_home/presentation/cubits/branch_packages_list_cubit/branch_packages_list_cubit.dart';
import 'package:gymbook/features/admin/admin_home/presentation/cubits/create_package_cubit/create_package_cubit.dart';
import 'package:gymbook/features/admin/admin_home/presentation/widgets/branch_buttom.dart';
import 'package:gymbook/features/admin/admin_home/presentation/widgets/manage_package_status.dart';
import 'package:gymbook/features/admin/admin_home/presentation/widgets/package_card.dart';
import 'package:gymbook/features/customer/customer_home/presentation/widgets/gym_pagination_widget.dart';

class ManagePackageScreenBody extends StatelessWidget {
  final int branchId;

  const ManagePackageScreenBody({super.key, required this.branchId});

  String _formatPrice(double value) {
    final hasFraction = value % 1 != 0;
    return hasFraction ? value.toStringAsFixed(2) : value.toStringAsFixed(0);
  }

  Future<void> _navigateAndRefresh(
    BuildContext context,
    PackageScreenArgs args,
  ) async {
    final saved = await GoRouter.of(
      context,
    ).push<bool>(Routes.addNewPackageScreen, extra: args);
    if (saved == true && context.mounted) {
      context.read<BranchPackagesListCubit>().loadPackages(
        branchId: branchId,
        refresh: true,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CreatePackageCubit, CreatePackageState>(
      listener: (context, state) {
        if (state is CreatePackageSuccess ||
            state is PackageStatusUpdated ||
            state is PackageDeleted) {
          context.read<BranchPackagesListCubit>().loadPackages(
            branchId: branchId,
            refresh: true,
          );
        }
      },
      child: BlocBuilder<BranchPackagesListCubit, BranchPackagesListState>(
        builder: (context, state) {
          final success = state is BranchPackagesListSuccess
              ? state.response
              : null;

          return RefreshIndicator(
            onRefresh: () => context
                .read<BranchPackagesListCubit>()
                .loadPackages(branchId: branchId, refresh: true),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: const AppbarSubscriptionWidget(
                      text: 'Manage Packages',
                    ),
                  ),
                  SizedBox(height: 24.h),

                  ManagePackageStatus(
                    totalCount: success?.meta.totalPackageCount ?? 0,
                    activeCount: success?.meta.activePackagesCount ?? 0,
                    averagePrice: success?.meta.averagePrice ?? 0.0,
                  ),
                  SizedBox(height: 24.h),

                  BranchButtom(
                    text: 'Add New Package',
                    icon: Icons.add,
                    onTap: () => _navigateAndRefresh(
                      context,
                      PackageScreenArgs(branchId: branchId),
                    ),
                  ),

                  SizedBox(height: 48.h),

                  AppText(
                    success != null
                        ? 'All Packages (${success.totalCount})'
                        : 'All Packages',
                    style: font18w700,
                    textPadding: EdgeInsets.symmetric(horizontal: 22.w),
                  ),

                  SizedBox(height: 16.h),

                  if (state is BranchPackagesListFailure)
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 32.w,
                        vertical: 40.h,
                      ),
                      child: Column(
                        children: [
                          Icon(
                            Icons.error_outline,
                            size: 48.sp,
                            color: Colors.red[300],
                          ),
                          SizedBox(height: 12.h),
                          AppText(
                            state.message,
                            style: font14w500.copyWith(color: Colors.red[400]),
                          ),
                          SizedBox(height: 16.h),
                          TextButton(
                            onPressed: () => context
                                .read<BranchPackagesListCubit>()
                                .loadPackages(
                                  branchId: branchId,
                                  refresh: true,
                                ),
                            child: const Text('Try Again'),
                          ),
                        ],
                      ),
                    )
                  else if (success != null)
                    ...success.data.map(
                      (pkg) => PackageCard(
                        onEdit: () => _navigateAndRefresh(
                          context,
                          PackageScreenArgs(
                            branchId: branchId,
                            packageItem: pkg,
                          ),
                        ),
                        onToggle: (newValue) {
                          context
                              .read<CreatePackageCubit>()
                              .togglePackageStatus(
                                branchId: branchId,
                                packageId: pkg.id,
                                isActive: newValue,
                              );
                        },
                        onDelete: () {
                          context.read<CreatePackageCubit>().deletePackage(
                            branchId: branchId,
                            packageId: pkg.id,
                          );
                        },
                        title: pkg.name,
                        months: pkg.durationInMonths,
                        freezes: pkg.numberOfFreezes,
                        price: _formatPrice(pkg.price),
                        isActive: pkg.isActive,
                        sideColor: pkg.isActive ? Colors.green : Colors.red,
                      ),
                    ),

                  SizedBox(height: 20.h),

                  if (success != null)
                    GymPaginationWidget(
                      totalPages: success.totalPages,
                      currentPage: success.currentPage,
                      onPageChanged: (page) {
                        context.read<BranchPackagesListCubit>().loadPackages(
                          branchId: branchId,
                          pageNumber: page,
                        );
                      },
                    ),

                  SizedBox(height: 40.h),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
