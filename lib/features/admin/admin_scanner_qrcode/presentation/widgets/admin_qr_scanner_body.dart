import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gymbook/core/theme/styles.dart';
import 'package:gymbook/core/widgets/custom_text.dart';
import 'package:gymbook/features/admin/admin_scanner_qrcode/domain/entities/admin_branch_option_entity.dart';
import 'package:gymbook/features/admin/admin_scanner_qrcode/presentation/cubits/admin_my_branches_cubit/admin_my_branches_cubit.dart';
import 'package:gymbook/features/admin/admin_scanner_qrcode/presentation/cubits/admin_qr_scanner_cubit/admin_qr_scanner_cubit.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class AdminQrScannerBody extends StatefulWidget {
  const AdminQrScannerBody({super.key});

  @override
  State<AdminQrScannerBody> createState() => _AdminQrScannerBodyState();
}

class _AdminQrScannerBodyState extends State<AdminQrScannerBody> {
  int? _selectedBranchId;

  @override
  void initState() {
    super.initState();
  }

  void _ensureBranchSelection(List<AdminBranchOptionEntity> branches) {
    if (branches.isEmpty) {
      _selectedBranchId = null;
      return;
    }
    final hasSelected = branches.any(
      (branch) => branch.id == _selectedBranchId,
    );
    if (!hasSelected) {
      _selectedBranchId = branches.first.id;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AdminQrScannerCubit, AdminQrScannerState>(
      listener: (context, state) {
        if (state.errorMessage != null &&
            state.errorMessage!.trim().isNotEmpty) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.errorMessage!)));
        }
        if (state.successMessage != null &&
            state.successMessage!.trim().isNotEmpty) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.successMessage!)));
        }
      },
      builder: (context, state) {
        final branchesState = context.watch<AdminMyBranchesCubit>().state;
        final isBranchLoading = branchesState is AdminMyBranchesLoading;
        final branches = switch (branchesState) {
          AdminMyBranchesSuccess(:final branches) => branches,
          _ => <AdminBranchOptionEntity>[],
        };

        if (branchesState is AdminMyBranchesSuccess) {
          _ensureBranchSelection(branches);
        }

        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          child: Column(
            children: [
              SizedBox(height: 40.h),
              AppText('Check-In Scanner', style: font20w700),
              SizedBox(height: 12.h),
              if (isBranchLoading)
                const LinearProgressIndicator()
              else if (branchesState is AdminMyBranchesFailure)
                Row(
                  children: [
                    Expanded(
                      child: AppText(
                        branchesState.message,
                        style: font14w500.copyWith(
                          color: const Color(0xffDC2626),
                        ),
                        maxLines: 2,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        context.read<AdminMyBranchesCubit>().loadBranches();
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                )
              else
                DropdownButtonFormField<int>(
                  value: _selectedBranchId,
                  decoration: const InputDecoration(
                    labelText: 'Branch',
                    border: OutlineInputBorder(),
                  ),
                  items: branches
                      .map(
                        (branch) => DropdownMenuItem<int>(
                          value: branch.id,
                          child: Text(branch.name),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedBranchId = value;
                    });
                  },
                ),
              SizedBox(height: 16.h),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16.r),
                  child: MobileScanner(
                    fit: BoxFit.cover,
                    onDetect: (capture) {
                      if (state.isSubmitting || _selectedBranchId == null)
                        return;
                      final value = capture.barcodes.first.rawValue;
                      if (value == null || value.trim().isEmpty) return;

                      context
                          .read<AdminQrScannerCubit>()
                          .submitFromScannedPayload(
                            rawValue: value,
                            branchId: _selectedBranchId!,
                          );
                    },
                  ),
                ),
              ),
              SizedBox(height: 12.h),
              if (state.isSubmitting)
                const CircularProgressIndicator()
              else
                AppText(
                  _selectedBranchId == null
                      ? 'Select a branch first'
                      : 'Scan customer QR to add check-in',
                  style: font14w500.copyWith(color: const Color(0xff6A7282)),
                ),
            ],
          ),
        );
      },
    );
  }
}
