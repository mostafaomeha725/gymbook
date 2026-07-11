import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gymbook/features/admin/admin_home/data/models/role_model.dart';
import 'package:gymbook/features/admin/admin_home/presentation/cubits/roles_cubit/roles_cubit.dart';
import 'package:gymbook/features/admin/admin_home/presentation/cubits/roles_cubit/roles_state.dart';
import 'package:gymbook/features/admin/admin_home/presentation/widgets/labeled_form_field.dart';
import 'package:gymbook/features/admin/admin_home/presentation/widgets/role_dropdown.dart';

class EmployeeRoleField extends StatelessWidget {
  final TextEditingController roleController;
  final ValueChanged<RoleModel?> onChanged;

  const EmployeeRoleField({
    super.key,
    required this.roleController,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return LabeledFormField(
      label: 'Role',
      input: BlocBuilder<RolesCubit, RolesState>(
        builder: (context, state) {
          return RoleDropdown(
            hintText: 'Choose a role...',
            isLoading: state is RolesLoading,
            roles: state is RolesLoaded ? state.roles : [],
            initialValue: roleController.text.isNotEmpty
                ? roleController.text
                : null,
            onChanged: onChanged,
          );
        },
      ),
    );
  }
}
