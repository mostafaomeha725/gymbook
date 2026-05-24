import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gymbook/core/utils/easy_loading.dart';
import 'package:gymbook/core/utils/validators.dart';
import 'package:gymbook/features/admin/admin_home/data/models/branch_list_model.dart';
import 'package:gymbook/features/admin/admin_home/domain/entities/branch_setup_details_entity.dart';
import 'package:gymbook/features/admin/admin_home/presentation/cubits/create_branch_cubit/create_branch_cubit.dart';
import 'package:gymbook/features/admin/admin_home/presentation/widgets/all_text_field_add_branch_one_content.dart';
import 'package:gymbook/features/auth/presentation/widgets/gym_type_selector.dart';

part 'all_text_field_add_branch_one_actions.dart';

class AllTextFieldAddBranchOne extends StatefulWidget {
  final BranchScreenArgs? args;
  final BranchSetupDetailsEntity? setupDetails;

  const AllTextFieldAddBranchOne({super.key, this.args, this.setupDetails});

  @override
  State<AllTextFieldAddBranchOne> createState() =>
      _AllTextFieldAddBranchOneState();
}

class _AllTextFieldAddBranchOneState extends State<AllTextFieldAddBranchOne> {
  final TextEditingController branchNameController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  String? _existingName;
  String? _existingEmail;
  String? _existingPhoneNumber;
  int? _existingBranchType;

  int? selectedBranchType;

  bool get _isEditMode => widget.args?.isEditMode == true;

  @override
  void initState() {
    super.initState();

    if (_isEditMode) {
      _applyExistingFromBranchArgs();
    }

    final setupDetails = widget.setupDetails;
    if (setupDetails != null) {
      _applyExistingFromSetupDetails(setupDetails);
    }
  }

  @override
  void didUpdateWidget(covariant AllTextFieldAddBranchOne oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.setupDetails != widget.setupDetails &&
        widget.setupDetails != null) {
      _applyExistingFromSetupDetails(widget.setupDetails!);
      setState(() {});
    }
  }

  @override
  void dispose() {
    branchNameController.dispose();
    phoneNumberController.dispose();
    emailController.dispose();
    super.dispose();
  }

  void _updateState(VoidCallback changes) {
    setState(changes);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CreateBranchCubit, CreateBranchState>(
      listener: (context, state) {
        if (state is CreateBranchSuccess) {
          hideLoading();
        }
      },
      child: AllTextFieldAddBranchOneContent(
        branchNameController: branchNameController,
        phoneNumberController: phoneNumberController,
        emailController: emailController,
        isEditMode: _isEditMode,
        branchNameHint: _branchNameHint,
        phoneNumberHint: _phoneNumberHint,
        emailHint: _emailHint,
        initialGymType: _existingGymType,
        submitText: _isEditMode ? 'Save Changes' : 'Create Branch',
        onGymTypeChanged: _onGymTypeChanged,
        onSubmit: () => _submitForm(context),
      ),
    );
  }
}
