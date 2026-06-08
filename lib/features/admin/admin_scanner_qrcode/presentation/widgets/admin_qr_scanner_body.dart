import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gymbook/core/widgets/custom_icon_appbar_widget.dart';
import 'package:gymbook/features/admin/admin_scanner_qrcode/domain/entities/admin_branch_option_entity.dart';
import 'package:gymbook/features/admin/admin_scanner_qrcode/presentation/cubits/admin_my_branches_cubit/admin_my_branches_cubit.dart';
import 'package:gymbook/features/admin/admin_scanner_qrcode/presentation/cubits/admin_qr_scanner_cubit/admin_qr_scanner_cubit.dart';
import 'package:gymbook/features/admin/admin_scanner_qrcode/presentation/widgets/admin_scanner_branch_selector.dart';
import 'package:gymbook/features/admin/admin_scanner_qrcode/presentation/widgets/admin_scanner_snackbar.dart';
import 'package:gymbook/features/admin/admin_scanner_qrcode/presentation/widgets/admin_qr_scanner_header.dart';
import 'package:gymbook/features/admin/admin_scanner_qrcode/presentation/widgets/admin_qr_scanner_camera_section.dart';

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
          AdminScannerSnackbar.show(
            context,
            state.errorMessage!,
            isError: true,
          );
        }
        if (state.successMessage != null &&
            state.successMessage!.trim().isNotEmpty) {
          AdminScannerSnackbar.show(
            context,
            state.successMessage!,
            isError: false,
          );
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

        return Container(
          color: const Color(0xFFF8FAFC),
          child: Column(
            children: [
              const AdminQrScannerHeader(),

              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: Column(
                    children: [
                      SizedBox(height: 12.h),

                      // Branch Selector Card
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 4.h,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16.r),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.04),
                              blurRadius: 15.r,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: AdminScannerBranchSelector(
                          isBranchLoading: isBranchLoading,
                          branchesState: branchesState,
                          branches: branches,
                          selectedBranchId: _selectedBranchId,
                          onChanged: (value) {
                            setState(() {
                              _selectedBranchId = value;
                            });
                          },
                        ),
                      ),

                      SizedBox(height: 12.h),

                      // Scanner Section
                      Expanded(
                        child: AdminQrScannerCameraSection(
                          isSubmitting: state.isSubmitting,
                          hasSelectedBranch: _selectedBranchId != null,
                          onDetect: (capture) {
                            if (state.isSubmitting ||
                                _selectedBranchId == null) {
                              return;
                            }
                            final value = capture.barcodes.first.rawValue;
                            if (value == null || value.trim().isEmpty) {
                              return;
                            }
                            context
                                .read<AdminQrScannerCubit>()
                                .submitFromScannedPayload(
                                  rawValue: value,
                                  branchId: _selectedBranchId!,
                                );
                          },
                        ),
                      ),
                      SizedBox(height: 104.h),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
