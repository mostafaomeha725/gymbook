import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gymbook/core/routes/route_paths.dart';
import 'package:gymbook/core/theme/styles.dart';
import 'package:gymbook/core/utils/easy_loading.dart';
import 'package:gymbook/core/widgets/appbar_subscription_widget.dart';
import 'package:gymbook/core/widgets/custom_text.dart';
import 'package:gymbook/features/admin/admin_home/presentation/models/add_edit_employee_screen_args.dart';
import 'package:gymbook/features/admin/admin_home/presentation/widgets/branch_buttom.dart';
import 'package:gymbook/features/admin/admin_home/presentation/widgets/employee_card.dart';
import 'package:gymbook/features/admin/admin_home/presentation/cubits/branch_employees_cubit/branch_employees_cubit.dart';
import 'package:gymbook/features/admin/admin_home/presentation/cubits/branch_employees_cubit/branch_employees_state.dart';

class AdminEmployeesScreenBody extends StatefulWidget {
  final int branchId;

  const AdminEmployeesScreenBody({super.key, required this.branchId});

  @override
  State<AdminEmployeesScreenBody> createState() =>
      _AdminEmployeesScreenBodyState();
}

class _AdminEmployeesScreenBodyState extends State<AdminEmployeesScreenBody> {
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
      context.read<BranchEmployeesCubit>().loadMore();
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<BranchEmployeesCubit, BranchEmployeesState>(
      listener: (context, state) {
        if (state is BranchEmployeesLoaded || state is BranchEmployeesError) {
          hideLoading();
        }
        if (state is EmployeeStatusToggleSuccess) {
          showSuccess(
            state.newStatus ? 'Employee activated' : 'Employee deactivated',
          );
        } else if (state is EmployeeStatusToggleError) {
          showError(state.message);
        }
      },
      child: Column(
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
                  branchId: widget.branchId,
                  isEditMode: false,
                ),
              );
              if (context.mounted) {
                context.read<BranchEmployeesCubit>().getBranchEmployees(
                  widget.branchId,
                );
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

                final items = cubit.items;
                final isFetchingMore = cubit.isFetchingMore;

                // Show empty state if no items
                if (items.isEmpty && state is! BranchEmployeesLoading) {
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

                final isToggling = state is EmployeeStatusToggling;

                return RefreshIndicator(
                  onRefresh: () async {
                    await cubit.getBranchEmployees(
                      widget.branchId,
                      isRefresh: true,
                    );
                  },
                  child: ListView.separated(
                    controller: _scrollController,
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: EdgeInsets.symmetric(
                      horizontal: 22.w,
                    ).copyWith(bottom: 100.h),
                    itemCount: items.length + (isFetchingMore ? 1 : 0),
                    separatorBuilder: (context, index) =>
                        SizedBox(height: 12.h),
                    itemBuilder: (context, index) {
                      if (index == items.length) {
                        return Padding(
                          padding: EdgeInsets.symmetric(vertical: 16.h),
                          child: const Center(
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }
                      final employee = items[index];
                      final isThisToggling =
                          isToggling &&
                          (state is EmployeeStatusToggling &&
                              state.employeeId == employee.id);
                      return IgnorePointer(
                        ignoring: isThisToggling,
                        child: AnimatedOpacity(
                          duration: const Duration(milliseconds: 200),
                          opacity: isThisToggling ? 0.6 : 1.0,
                          child: EmployeeCard(
                            name: '${employee.firstName} ${employee.lastName}'
                                .trim(),
                            role: employee.roleName,
                            phone: employee.phone,
                            initials: employee.firstName.isNotEmpty
                                ? employee.firstName
                                      .substring(0, 1)
                                      .toUpperCase()
                                : 'E',
                            status: employee.isActive,
                            onEdit: () async {
                              await GoRouter.of(context).push(
                                Routes.addEditEmployeeScreen,
                                extra: AddEditEmployeeScreenArgs(
                                  branchId: widget.branchId,
                                  isEditMode: true,
                                  employee: employee,
                                ),
                              );
                              if (context.mounted) {
                                context
                                    .read<BranchEmployeesCubit>()
                                    .getBranchEmployees(widget.branchId);
                              }
                            },
                            onToggleStatus: (newStatus) {
                              context
                                  .read<BranchEmployeesCubit>()
                                  .toggleEmployeeStatus(
                                    branchId: widget.branchId,
                                    employeeId: employee.id,
                                    employee: employee,
                                    newStatus: newStatus,
                                  );
                            },
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
