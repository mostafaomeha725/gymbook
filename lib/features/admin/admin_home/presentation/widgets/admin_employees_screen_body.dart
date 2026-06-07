import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gymbook/core/widgets/appbar_subscription_widget.dart';
import 'package:gymbook/features/admin/admin_home/presentation/widgets/branch_buttom.dart';
import 'package:gymbook/features/admin/admin_home/presentation/widgets/employee_card.dart';

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
        BranchButtom(text: 'Add New Employee', icon: Icons.add, onTap: () {}),
        SizedBox(height: 24.h),
        Expanded(
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: 22.w),
            children: [
              EmployeeCard(
                name: 'Ahmed Hassan',
                role: 'Gator',
                phone: '010-1234-5678',
                initials: 'AH',
                status: true,
                onEdit: () {
                  // TODO: handle edit
                },
              ),
              SizedBox(height: 12.h),
              EmployeeCard(
                name: 'Sara Mahmoud',
                role: 'Trainer',
                phone: '012-8765-4321',
                initials: 'SM',
                status: true, // Active
                onEdit: () {
                  // TODO: handle edit
                },
                onToggleStatus: (val) {
                  // TODO: Toggle status logic
                },
              ),
              SizedBox(height: 12.h),
              EmployeeCard(
                name: 'Mohamed Ali',
                role: 'Receptionist',
                phone: '011-5555-9999',
                initials: 'MA',
                status: false, // Inactive
                onEdit: () {
                  // TODO: handle edit
                },
                onToggleStatus: (val) {
                  // TODO: Toggle status logic
                },
              ),
              SizedBox(height: 12.h),
              EmployeeCard(
                name: 'Nour Khaled',
                role: 'Gator',
                phone: '015-3333-7777',
                initials: 'NK',
                status: true, // Active
                onEdit: () {
                  // TODO: handle edit
                },
                onToggleStatus: (val) {
                  // TODO: Toggle status logic
                },
              ),
              EmployeeCard(
                name: 'Nour Khaled',
                role: 'Gator',
                phone: '015-3333-7777',
                initials: 'NK',
                status: true, // Active
                onEdit: () {
                  // TODO: handle edit
                },
                onToggleStatus: (val) {
                  // TODO: Toggle status logic
                },
              ),
              EmployeeCard(
                name: 'Nour Khaled',
                role: 'Gator',
                phone: '015-3333-7777',
                initials: 'NK',
                status: true, // Active
                onEdit: () {
                  // TODO: handle edit
                },
                onToggleStatus: (val) {
                  // TODO: Toggle status logic
                },
              ),
              EmployeeCard(
                name: 'Nour Khaled',
                role: 'Gator',
                phone: '015-3333-7777',
                initials: 'NK',
                status: true, // Active
                onEdit: () {
                  // TODO: handle edit
                },
                onToggleStatus: (val) {
                  // TODO: Toggle status logic
                },
              ),
              SizedBox(height: 24.h),
            ],
          ),
        ),
      ],
    );
  }
}
