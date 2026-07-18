import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gymbook/core/widgets/bouncing_social_button.dart';
import 'package:gymbook/features/admin/admin_home/domain/entities/package_entity.dart';
import 'package:gymbook/features/admin/admin_home/presentation/cubits/branch_packages_list_cubit/branch_packages_list_cubit.dart';
import 'package:gymbook/features/admin/admin_home/presentation/cubits/branch_packages_list_cubit/branch_packages_list_state.dart';

class SubscriptionSubmitSection extends StatelessWidget {
  final int? selectedPackageIndex;
  final int userTypeIndex;
  final VoidCallback? Function(PackageEntity? pkg) onSubmit;

  const SubscriptionSubmitSection({
    super.key,
    required this.selectedPackageIndex,
    required this.userTypeIndex,
    required this.onSubmit,
  });

  List<PackageEntity> _activePackages(BranchPackagesListState state) {
    if (state is BranchPackagesListSuccess) {
      return state.response.data.where((p) => p.isActive).toList();
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BranchPackagesListCubit, BranchPackagesListState>(
      builder: (context, packagesState) {
        final packages = _activePackages(packagesState);

        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 22.w),
          child: BouncingSocialButton(
            text: userTypeIndex == 0 ? 'Add Member' : 'Add Subscription',
            textSize: 16.sp,
            icon: Icons.check,
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF0EA5E9), Color(0xFF0284C7)],
            ),
            onTap: onSubmit(
              (selectedPackageIndex != null &&
                      packages.isNotEmpty &&
                      selectedPackageIndex! < packages.length)
                  ? packages[selectedPackageIndex!]
                  : null,
            ),
          ),
        );
      },
    );
  }
}
