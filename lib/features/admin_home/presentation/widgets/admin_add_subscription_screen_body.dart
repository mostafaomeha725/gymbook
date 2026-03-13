import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:gymbook/core/di/services_locator.dart';
import 'package:gymbook/core/widgets/appbar_subscription_widget.dart';
import 'package:gymbook/features/admin_home/presentation/cubits/add_member_cubit/add_member_cubit.dart';
import 'package:gymbook/features/admin_home/presentation/cubits/add_subscription_cubit/add_subscription_cubit.dart';
import 'package:gymbook/features/admin_home/presentation/cubits/branch_packages_list_cubit/branch_packages_list_cubit.dart';
import 'package:gymbook/features/admin_home/presentation/widgets/existing_user_form.dart';
import 'package:gymbook/features/admin_home/presentation/widgets/new_user_form.dart';
import 'package:gymbook/features/admin_home/presentation/widgets/packages_list_section.dart';
import 'package:gymbook/features/admin_home/presentation/widgets/subscription_submit_section.dart';
import 'package:gymbook/features/admin_home/presentation/widgets/user_type_selector.dart';

class AdminAddSubscriptionScreenBody extends StatefulWidget {
  final int branchId;
  const AdminAddSubscriptionScreenBody({super.key, required this.branchId});

  @override
  State<AdminAddSubscriptionScreenBody> createState() =>
      _AdminAddSubscriptionScreenBodyState();
}

class _AdminAddSubscriptionScreenBodyState
    extends State<AdminAddSubscriptionScreenBody> {
  // Existing user
  final _emailController = TextEditingController();

  // New user
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _newUserEmailController = TextEditingController();

  int? _selectedPackageIndex;

  /// 0 = New User, 1 = Existing User
  int _userTypeIndex = 1;

  @override
  void dispose() {
    _emailController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    _newUserEmailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) =>
              sl<BranchPackagesListCubit>()
                ..loadPackages(branchId: widget.branchId, refresh: true),
        ),
        BlocProvider(create: (_) => sl<AddSubscriptionCubit>()),
        BlocProvider(create: (_) => sl<AddMemberCubit>()),
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<AddSubscriptionCubit, AddSubscriptionState>(
            listener: (context, state) {
              if (state is AddSubscriptionSuccess) {
                GoRouter.of(context).pop(true);
              }
            },
          ),
          BlocListener<AddMemberCubit, AddMemberState>(
            listener: (context, state) {
              if (state is AddMemberSuccess) {
                GoRouter.of(context).pop(true);
              }
            },
          ),
        ],
        child: Builder(
          builder: (context) => SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const AppbarSubscriptionWidget(text: 'Add Subscription'),
                SizedBox(height: 24.h),

                // ── User type toggle ─────────────────────────────────────
                UserTypeSelector(
                  selectedIndex: _userTypeIndex,
                  onChanged: (index) => setState(() {
                    _userTypeIndex = index;
                    _selectedPackageIndex = null;
                  }),
                ),
                SizedBox(height: 24.h),

                // ── Form (switches by user type) ─────────────────────────
                if (_userTypeIndex == 0) ...[
                  NewUserForm(
                    firstNameController: _firstNameController,
                    lastNameController: _lastNameController,
                    phoneController: _phoneController,
                    emailController: _newUserEmailController,
                  ),
                ] else ...[
                  ExistingUserForm(emailController: _emailController),
                ],
                SizedBox(height: 24.h),

                // ── Packages + summary ───────────────────────────────────
                PackagesListSection(
                  selectedPackageIndex: _selectedPackageIndex,
                  onPackageSelected: (index) =>
                      setState(() => _selectedPackageIndex = index),
                ),

                // ── Submit button ────────────────────────────────────────
                SubscriptionSubmitSection(
                  selectedPackageIndex: _selectedPackageIndex,
                  userTypeIndex: _userTypeIndex,
                  onSubmit: (pkg) => () {
                    if (_userTypeIndex == 0) {
                      context.read<AddMemberCubit>().addMember(
                        branchId: widget.branchId,
                        firstName: _firstNameController.text,
                        lastName: _lastNameController.text,
                        phoneNumber: _phoneController.text,
                        email: _newUserEmailController.text,
                        packageId: pkg.id,
                      );
                    } else {
                      context.read<AddSubscriptionCubit>().addSubscription(
                        branchId: widget.branchId,
                        email: _emailController.text,
                        packageId: pkg.id,
                      );
                    }
                  },
                ),

                SizedBox(height: 40.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
