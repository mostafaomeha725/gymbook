import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gymbook/core/routes/route_paths.dart';
import 'package:gymbook/core/theme/styles.dart';
import 'package:gymbook/core/widgets/appbar_subscription_widget.dart';
import 'package:gymbook/core/widgets/custom_text.dart';
import 'package:gymbook/features/admin/admin_home/presentation/models/add_edit_employee_screen_args.dart';
import 'package:gymbook/features/admin/admin_home/presentation/widgets/branch_buttom.dart';
import 'package:gymbook/features/admin/admin_home/presentation/widgets/employee_card.dart';
import 'package:gymbook/features/admin/admin_home/presentation/cubits/branch_employees_cubit/branch_employees_cubit.dart';
import 'package:gymbook/features/admin/admin_home/presentation/cubits/branch_employees_cubit/branch_employees_state.dart';
import 'package:gymbook/features/customer/customer_home/presentation/widgets/gym_pagination_widget.dart';

class AdminEmployeesScreenBody extends StatelessWidget {
  final int branchId;

  const AdminEmployeesScreenBody({super.key, required this.branchId});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: const AppbarSubscriptionWidget(text: 'Employees'),
        ),
        SizedBox(height: 24.h),
        BranchButtom(
          text: 'Add New Employee',
          icon: Icons.add,
          onTap: () async {
            await GoRouter.of(context).push(
              Routes.addEditEmployeeScreen,
              extra: AddEditEmployeeScreenArgs(
                branchId: branchId,
                isEditMode: false,
              ),
            );
            if (context.mounted) {
              context.read<BranchEmployeesCubit>().getBranchEmployees(branchId);
            }
          },
        ),
        SizedBox(height: 24.h),
        Expanded(
          child: BlocBuilder<BranchEmployeesCubit, BranchEmployeesState>(
            builder: (context, state) {
              if (state is BranchEmployeesLoading &&
                  !state.isPaginationLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is BranchEmployeesError) {
                return Center(child: Text(state.message));
              }

              final cubit = context.read<BranchEmployeesCubit>();
              final response = cubit.currentResponse;

              if (response == null || response.data.isEmpty) {
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 48.h),
                  child: Column(
                    children: [
                      Icon(
                        Icons.people_outline,
                        size: 64.sp,
                        color: Colors.grey.shade300,
                      ),
                      SizedBox(height: 16.h),
                      AppText(
                        'No employees found',
                        style: font16w600.copyWith(
                          color: const Color(0xff475569),
                        ),
                        alignment: AlignmentDirectional.center,
                      ),
                      SizedBox(height: 8.h),
                      AppText(
                        'Add a new employee to manage your branch.',
                        style: font14w400.copyWith(
                          color: const Color(0xff94A3B8),
                        ),
                        alignment: AlignmentDirectional.center,
                      ),
                    ],
                  ),
                );
              }

              return Stack(
                children: [
                  ListView.separated(
                    padding: EdgeInsets.symmetric(
                      horizontal: 22.w,
                    ).copyWith(bottom: 100.h),
                    itemCount: response.totalPages > 1
                        ? response.data.length + 1
                        : response.data.length,
                    separatorBuilder: (context, index) =>
                        SizedBox(height: 12.h),
                    itemBuilder: (context, index) {
                      if (index == response.data.length) {
                        return GymPaginationWidget(
                          totalPages: response.totalPages,
                          currentPage: response.currentPage,
                          onPageChanged: (page) {
                            cubit.getBranchEmployees(
                              branchId,
                              pageNumber: page,
                            );
                          },
                        );
                      }
                      final employee = response.data[index];
                      return EmployeeCard(
                        name: '${employee.firstName} ${employee.lastName}'
                            .trim(),
                        role: employee.roleName,
                        phone: employee.phone,
                        initials: employee.firstName.isNotEmpty
                            ? employee.firstName.substring(0, 1).toUpperCase()
                            : 'E',
                        status: employee.isActive,
                        onEdit: () async {
                          await GoRouter.of(context).push(
                            Routes.addEditEmployeeScreen,
                            extra: AddEditEmployeeScreenArgs(
                              branchId: branchId,
                              isEditMode: true,
                              employee: employee,
                            ),
                          );
                          if (context.mounted) {
                            context
                                .read<BranchEmployeesCubit>()
                                .getBranchEmployees(branchId);
                          }
                        },
                      );
                    },
                  ),
                  if (state is BranchEmployeesLoading &&
                      state.isPaginationLoading)
                    Container(
                      color: Colors.white.withOpacity(0.5),
                      child: const Center(child: CircularProgressIndicator()),
                    ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}
