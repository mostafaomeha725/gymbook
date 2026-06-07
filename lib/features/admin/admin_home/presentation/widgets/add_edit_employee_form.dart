import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gymbook/core/widgets/app_form_field.dart';
import 'package:gymbook/features/admin/admin_home/presentation/cubits/roles_cubit/roles_cubit.dart';
import 'package:gymbook/features/admin/admin_home/presentation/cubits/roles_cubit/roles_state.dart';
import 'package:gymbook/features/admin/admin_home/presentation/models/add_edit_employee_screen_args.dart';
import 'package:gymbook/features/admin/admin_home/presentation/widgets/add_edit_employee_buttons.dart';
import 'package:gymbook/features/admin/admin_home/presentation/widgets/role_dropdown.dart';
import 'package:gymbook/features/admin/admin_home/presentation/widgets/labeled_form_field.dart';

class AddEditEmployeeForm extends StatefulWidget {
  final AddEditEmployeeScreenArgs args;

  const AddEditEmployeeForm({super.key, required this.args});

  @override
  State<AddEditEmployeeForm> createState() => _AddEditEmployeeFormState();
}

class _AddEditEmployeeFormState extends State<AddEditEmployeeForm> {
  final _formKey = GlobalKey<FormState>();

  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _roleController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isPasswordObscure = true;
  bool _isConfirmPasswordObscure = true;

  @override
  void initState() {
    super.initState();
    if (widget.args.isEditMode) {
      // Assuming employee data mapping here if available
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _roleController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.args.isEditMode;

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: LabeledFormField(
                  label: 'First Name',
                  input: AppFormField(
                    controller: _firstNameController,
                    hintText: 'First Name',
                    prefixIcon: const Icon(Icons.person_outline, size: 20),
                  ),
                ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: LabeledFormField(
                  label: 'Last Name',
                  input: AppFormField(
                    controller: _lastNameController,
                    hintText: 'Last Name',
                    prefixIcon: const Icon(Icons.person_outline, size: 20),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          LabeledFormField(
            label: 'Email',
            input: AppFormField(
              controller: _emailController,
              hintText: 'email@example.com',
              keyboardType: TextInputType.emailAddress,
              prefixIcon: const Icon(Icons.email_outlined, size: 20),
            ),
          ),
          SizedBox(height: 16.h),
          LabeledFormField(
            label: 'Phone Number',
            input: AppFormField(
              controller: _phoneController,
              hintText: '010-XXXX-XXXX',
              keyboardType: TextInputType.phone,
              prefixIcon: const Icon(Icons.phone_outlined, size: 20),
            ),
          ),
          SizedBox(height: 16.h),
          LabeledFormField(
            label: 'Role',
            input: BlocBuilder<RolesCubit, RolesState>(
              builder: (context, state) {
                return RoleDropdown(
                  hintText: 'Choose a role...',
                  isLoading: state is RolesLoading,
                  roles: state is RolesLoaded ? state.roles : [],
                  initialValue: _roleController.text.isNotEmpty
                      ? _roleController.text
                      : null,
                  onChanged: (role) {
                    if (role != null) {
                      _roleController.text = role.name;
                    } else {
                      _roleController.clear();
                    }
                  },
                );
              },
            ),
          ),
          SizedBox(height: 16.h),
          LabeledFormField(
            label: 'Password',
            input: AppFormField(
              controller: _passwordController,
              hintText: isEdit
                  ? 'Leave blank to keep current'
                  : 'Min. 6 characters',
              obsecureText: _isPasswordObscure,
              maxLines: 1,
              prefixIcon: const Icon(Icons.lock_outline, size: 20),
              suffixIcon: GestureDetector(
                onTap: () => setState(() {
                  _isPasswordObscure = !_isPasswordObscure;
                }),
                child: Icon(
                  _isPasswordObscure
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  size: 20,
                ),
              ),
            ),
          ),
          SizedBox(height: 16.h),
          LabeledFormField(
            label: 'Confirm Password',
            input: AppFormField(
              controller: _confirmPasswordController,
              hintText: 'Re-enter password',
              maxLines: 1,
              obsecureText: _isConfirmPasswordObscure,
              prefixIcon: const Icon(Icons.lock_outline, size: 20),
              suffixIcon: GestureDetector(
                onTap: () => setState(() {
                  _isConfirmPasswordObscure = !_isConfirmPasswordObscure;
                }),
                child: Icon(
                  _isConfirmPasswordObscure
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  size: 20,
                ),
              ),
            ),
          ),
          SizedBox(height: 32.h),
          AddEditEmployeeButtons(
            isEdit: isEdit,
            onSave: () {
              if (_formKey.currentState?.validate() ?? false) {
                // TODO: save/update logic
              }
            },
          ),
          SizedBox(height: 32.h),
        ],
      ),
    );
  }
}
