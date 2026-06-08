import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gymbook/core/theme/styles.dart';
import 'package:gymbook/core/widgets/custom_text.dart';
import 'package:gymbook/features/admin/admin_scanner_qrcode/domain/entities/admin_branch_option_entity.dart';
import 'package:gymbook/features/admin/admin_scanner_qrcode/presentation/cubits/admin_my_branches_cubit/admin_my_branches_cubit.dart';

class AdminScannerBranchSelector extends StatelessWidget {
  final bool isBranchLoading;
  final AdminMyBranchesState branchesState;
  final List<AdminBranchOptionEntity> branches;
  final int? selectedBranchId;
  final ValueChanged<int?> onChanged;

  const AdminScannerBranchSelector({
    super.key,
    required this.isBranchLoading,
    required this.branchesState,
    required this.branches,
    required this.selectedBranchId,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    if (isBranchLoading) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 16.h),
        child: const LinearProgressIndicator(color: Color(0xFF0EA5E9)),
      );
    } else if (branchesState is AdminMyBranchesFailure) {
      return Row(
        children: [
          Icon(Icons.error_outline, color: const Color(0xffDC2626), size: 24.w),
          SizedBox(width: 12.w),
          Expanded(
            child: AppText(
              (branchesState as AdminMyBranchesFailure).message,
              style: font14w500.copyWith(color: const Color(0xffDC2626)),
              maxLines: 2,
            ),
          ),
          TextButton(
            onPressed: () {
              context.read<AdminMyBranchesCubit>().loadBranches();
            },
            child: const Text(
              'Retry',
              style: TextStyle(color: Color(0xFF0EA5E9)),
            ),
          ),
        ],
      );
    } else {
      return DropdownButtonHideUnderline(
        child: DropdownButton<int>(
          value: selectedBranchId,
          isExpanded: true,
          icon: Icon(
            Icons.keyboard_arrow_down,
            color: const Color(0xFF0EA5E9),
            size: 24.w,
          ),
          hint: AppText(
            'Select Branch',
            alignment: AlignmentDirectional.centerStart,
            style: font14w500.copyWith(color: const Color(0xFF9CA3AF)),
          ),
          items: branches.map((branch) {
            return DropdownMenuItem<int>(
              value: branch.id,
              child: Row(
                children: [
                  Icon(
                    Icons.storefront,
                    color: const Color(0xFF6B7280),
                    size: 20.w,
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: AppText(
                      branch.name,
                      alignment: AlignmentDirectional.centerStart,
                      style: font14w700.copyWith(
                        color: const Color(0xFF374151),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      );
    }
  }
}
