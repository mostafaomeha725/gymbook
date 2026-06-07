import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:gymbook/core/utils/easy_loading.dart';
import 'package:gymbook/features/admin/admin_home/data/models/employee_model.dart';
import 'package:gymbook/features/admin/admin_home/presentation/cubits/add_edit_employee_cubit/add_edit_employee_cubit.dart';
import 'package:gymbook/features/admin/admin_home/presentation/cubits/add_edit_employee_cubit/add_edit_employee_state.dart';
import 'package:gymbook/features/admin/admin_home/presentation/models/add_edit_employee_screen_args.dart';
import 'package:gymbook/features/admin/admin_home/presentation/widgets/add_edit_employee_buttons.dart';
import 'package:gymbook/features/admin/admin_home/presentation/widgets/employee_contact_fields.dart';
import 'package:gymbook/features/admin/admin_home/presentation/widgets/employee_name_fields.dart';
import 'package:gymbook/features/admin/admin_home/presentation/widgets/employee_password_fields.dart';
import 'package:gymbook/features/admin/admin_home/presentation/widgets/employee_role_field.dart';
import 'package:gymbook/features/admin/admin_home/presentation/widgets/employee_status_switch.dart';

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

  int? _selectedRoleId;
  bool _isActive = true;
  int? _employeeId;

  @override
  void initState() {
    super.initState();
    if (widget.args.isEditMode && widget.args.employee != null) {
      final emp = widget.args.employee as EmployeeModel;
      _employeeId = emp.id;
      _firstNameController.text = emp.firstName;
      _lastNameController.text = emp.lastName;
      _emailController.text = emp.email;
      _phoneController.text = emp.phone;
      _roleController.text = emp.roleName;
      _selectedRoleId = emp.roleId;
      _isActive = emp.isActive;
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

  void _onSave() {
    if (_formKey.currentState?.validate() ?? false) {
      if (_selectedRoleId == null) {
        showError('Please select a role');
        return;
      }

      final body = <String, dynamic>{
        'branchId': widget.args.branchId,
        'employeeRoleId': _selectedRoleId,
        'firstName': _firstNameController.text.trim(),
        'lastName': _lastNameController.text.trim(),
        'email': _emailController.text.trim(),
        'phoneNumber': _phoneController.text.trim(),
      };

      if (widget.args.isEditMode) {
        body['Active'] = _isActive;
        context.read<AddEditEmployeeCubit>().updateEmployee(_employeeId!, body);
      } else {
        if (_passwordController.text != _confirmPasswordController.text) {
          showError('Passwords do not match');
          return;
        }
        body['password'] = _passwordController.text;
        body['confirmPassword'] = _confirmPasswordController.text;
        context.read<AddEditEmployeeCubit>().addEmployee(body);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.args.isEditMode;

    return BlocListener<AddEditEmployeeCubit, AddEditEmployeeState>(
      listener: (context, state) {
        if (state is AddEditEmployeeLoading) {
          showLoading();
        } else if (state is AddEditEmployeeSuccess) {
          hideLoading();
          showSuccess(
            isEdit
                ? 'Employee updated successfully'
                : 'Employee added successfully',
          );
          context.pop();
        } else if (state is AddEditEmployeeError) {
          hideLoading();
          showError(state.message);
        }
      },
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            EmployeeNameFields(
              firstNameController: _firstNameController,
              lastNameController: _lastNameController,
            ),
            SizedBox(height: 16.h),
            EmployeeContactFields(
              emailController: _emailController,
              phoneController: _phoneController,
            ),
            SizedBox(height: 16.h),
            EmployeeRoleField(
              roleController: _roleController,
              onChanged: (role) {
                if (role != null) {
                  _roleController.text = role.name;
                  _selectedRoleId = role.id;
                } else {
                  _roleController.clear();
                  _selectedRoleId = null;
                }
              },
            ),
            if (isEdit) ...[
              SizedBox(height: 16.h),
              EmployeeStatusSwitch(
                isActive: _isActive,
                onChanged: (val) {
                  setState(() {
                    _isActive = val;
                  });
                },
              ),
            ],
            if (!isEdit) ...[
              SizedBox(height: 16.h),
              EmployeePasswordFields(
                passwordController: _passwordController,
                confirmPasswordController: _confirmPasswordController,
                isEdit: isEdit,
              ),
            ],
            SizedBox(height: 32.h),
            AddEditEmployeeButtons(isEdit: isEdit, onSave: _onSave),
            SizedBox(height: 32.h),
          ],
        ),
      ),
    );
  }
}
