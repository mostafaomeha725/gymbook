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
import 'package:gymbook/features/admin/admin_home/presentation/cubits/branch_packages_list_cubit/branch_packages_list_state.dart';
import 'package:gymbook/features/admin/admin_home/presentation/cubits/create_package_cubit/create_package_cubit.dart';
import 'package:gymbook/features/admin/admin_home/presentation/widgets/branch_buttom.dart';
import 'package:gymbook/core/utils/easy_loading.dart';
import 'package:gymbook/features/admin/admin_home/presentation/widgets/package_card.dart';

class ManagePackageScreenBody extends StatefulWidget {
  final int branchId;

  const ManagePackageScreenBody({super.key, required this.branchId});

  @override
  State<ManagePackageScreenBody> createState() =>
      _ManagePackageScreenBodyState();
}

class _ManagePackageScreenBodyState extends State<ManagePackageScreenBody> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (!mounted || !_scrollController.hasClients) return;
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.8) {
      context.read<BranchPackagesListCubit>().loadMore();
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

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
        branchId: widget.branchId,
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
            branchId: widget.branchId,
            refresh: true,
          );
        }
      },
      child: BlocListener<BranchPackagesListCubit, BranchPackagesListState>(
        listener: (context, state) {
          if (state is BranchPackagesListSuccess ||
              state is BranchPackagesListFailure) {
            hideLoading();
          }
        },
        child: BlocBuilder<BranchPackagesListCubit, BranchPackagesListState>(
          builder: (context, state) {
            final success = state is BranchPackagesListSuccess
                ? state.response
                : null;

            return Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: const AppbarSubscriptionWidget(
                    text: 'Manage Packages',
                  ),
                ),
                SizedBox(height: 24.h),
                BranchButtom(
                  text: 'Add New Package',
                  icon: Icons.add,
                  onTap: () => _navigateAndRefresh(
                    context,
                    PackageScreenArgs(branchId: widget.branchId),
                  ),
                ),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () => context
                        .read<BranchPackagesListCubit>()
                        .loadPackages(branchId: widget.branchId, refresh: true),
                    child: ListView(
                      controller: _scrollController,
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: EdgeInsets.only(bottom: 100.h),
                      children: [
                        SizedBox(height: 16.h),

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
                                  style: font14w500.copyWith(
                                    color: Colors.red[400],
                                  ),
                                ),
                                SizedBox(height: 16.h),
                                TextButton(
                                  onPressed: () => context
                                      .read<BranchPackagesListCubit>()
                                      .loadPackages(
                                        branchId: widget.branchId,
                                        refresh: true,
                                      ),
                                  child: const Text('Try Again'),
                                ),
                              ],
                            ),
                          )
                        else if (state is BranchPackagesListSuccess)
                          if (state.items.isEmpty)
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 40.h),
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.inventory_2_outlined,
                                    size: 64.sp,
                                    color: Colors.grey.shade300,
                                  ),
                                  SizedBox(height: 16.h),
                                  AppText(
                                    'No packages found',
                                    style: font16w600.copyWith(
                                      color: const Color(0xff475569),
                                    ),
                                    alignment: AlignmentDirectional.center,
                                  ),
                                  SizedBox(height: 8.h),
                                  AppText(
                                    'Add a new package to get started.',
                                    style: font14w400.copyWith(
                                      color: const Color(0xff94A3B8),
                                    ),
                                    alignment: AlignmentDirectional.center,
                                  ),
                                ],
                              ),
                            )
                          else
                            ...state.items.map(
                              (pkg) => PackageCard(
                                onEdit: () => _navigateAndRefresh(
                                  context,
                                  PackageScreenArgs(
                                    branchId: widget.branchId,
                                    packageItem: pkg,
                                  ),
                                ),
                                onToggle: (newValue) {
                                  context
                                      .read<CreatePackageCubit>()
                                      .togglePackageStatus(
                                        branchId: widget.branchId,
                                        packageId: pkg.id,
                                        isActive: newValue,
                                      );
                                },
                                onDelete: () {
                                  context
                                      .read<CreatePackageCubit>()
                                      .deletePackage(
                                        branchId: widget.branchId,
                                        packageId: pkg.id,
                                      );
                                },
                                title: pkg.name,
                                months: pkg.durationInMonths,
                                freezes: pkg.numberOfFreezes,
                                price: _formatPrice(pkg.price),
                                isActive: pkg.isActive,
                                sideColor: pkg.isActive
                                    ? Colors.green
                                    : Colors.red,
                              ),
                            ),
                        SizedBox(height: 20.h),
                        if (state is BranchPackagesListSuccess &&
                            state.isFetchingMore)
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 16.h),
                            child: const Center(
                              child: CircularProgressIndicator(),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
