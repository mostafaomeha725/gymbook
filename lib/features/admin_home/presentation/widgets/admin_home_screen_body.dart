import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gymbook/core/theme/styles.dart';
import 'package:gymbook/core/widgets/custom_text.dart';
import 'package:gymbook/features/admin_home/presentation/cubits/branches_list_cubit/branches_list_cubit.dart';
import 'package:gymbook/features/admin_home/presentation/widgets/branches_list_view.dart';
import 'package:gymbook/features/home/presentation/widgets/appbar_admin_home_widget.dart';
import 'package:gymbook/features/home/presentation/widgets/gym_pagination_widget.dart';

class AdminHomeScreenBody extends StatelessWidget {
  const AdminHomeScreenBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BranchesListCubit, BranchesListState>(
      builder: (context, state) {
        return RefreshIndicator(
          onRefresh: () =>
              context.read<BranchesListCubit>().loadBranches(refresh: true),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Column(
                    children: [
                      AppbarAdminHomeWidget(
                        userName: 'My Branches',
                        location: 'Manage all your gym locations',
                        onSearchChanged: (value) => context
                            .read<BranchesListCubit>()
                            .loadBranches(search: value),
                      ),
                      SizedBox(height: 16.h),
                      if (state is BranchesListSuccess)
                        AppText(
                          'All Branches (${state.response.totalCount})',
                          style: font20w700,
                          textPadding: EdgeInsets.symmetric(horizontal: 16.w),
                        )
                      else
                        AppText(
                          'All Branches',
                          style: font20w700,
                          textPadding: EdgeInsets.symmetric(horizontal: 16.w),
                        ),
                      SizedBox(height: 16.h),
                    ],
                  ),
                ),

                if (state is BranchesListLoading)
                  Padding(
                    padding: EdgeInsets.only(top: 60.h),
                    child: const CircularProgressIndicator(),
                  )
                else if (state is BranchesListFailure)
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 32.w,
                      vertical: 60.h,
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
                              .read<BranchesListCubit>()
                              .loadBranches(refresh: true),
                          child: const Text('Try Again'),
                        ),
                      ],
                    ),
                  )
                else if (state is BranchesListSuccess)
                  Column(
                    children: [
                      BranchesListView(branches: state.response.data),
                      if (state.response.totalPages > 1)
                        GymPaginationWidget(
                          totalPages: state.response.totalPages,
                          currentPage: state.response.currentPage,
                          onPageChanged: (page) {
                            context.read<BranchesListCubit>().loadBranches(
                              pageNumber: page,
                            );
                          },
                        ),
                    ],
                  )
                else
                  const SizedBox.shrink(),

                SizedBox(height: 152.h),
              ],
            ),
          ),
        );
      },
    );
  }
}
