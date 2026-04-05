part of 'all_text_field_add_branch_one.dart';

extension _AllTextFieldAddBranchOneActions on _AllTextFieldAddBranchOneState {
  String get _branchNameHint {
    if (!_isEditMode) return 'Enter branch name';
    return (_existingName?.trim().isNotEmpty ?? false)
        ? _existingName!
        : 'Enter branch name';
  }

  String get _phoneNumberHint {
    if (!_isEditMode) return '+20 XXX XXX XXX';
    return (_existingPhoneNumber?.trim().isNotEmpty ?? false)
        ? _existingPhoneNumber!
        : '+20 XXX XXX XXX';
  }

  String get _emailHint {
    if (!_isEditMode) return 'branch.email@example.com';
    return (_existingEmail?.trim().isNotEmpty ?? false)
        ? _existingEmail!
        : 'branch.email@example.com';
  }

  GymType? get _existingGymType {
    final type = _existingBranchType;
    if (type == 0) return GymType.menOnly;
    if (type == 1) return GymType.womenOnly;
    if (type == 2) return GymType.mixed;
    return null;
  }

  void _onGymTypeChanged(GymType value) {
    _updateState(() {
      // Convert GymType enum to branch type int: menOnly=0, womenOnly=1, mixed=2
      selectedBranchType = value == GymType.menOnly
          ? 0
          : value == GymType.womenOnly
          ? 1
          : 2;
    });
  }

  void _submitForm(BuildContext context) {
    final branchNameInput = branchNameController.text.trim();
    final emailInput = _normalizeEmail(emailController.text);
    final phoneNumberInput = _normalizePhoneNumber(phoneNumberController.text);
    final isUpdateRequest =
        widget.args?.isEditMode == true && (widget.args?.branchId ?? 0) > 0;

    final branchName = isUpdateRequest && branchNameInput.isEmpty
        ? (_existingName ?? '').trim()
        : branchNameInput;

    final email = isUpdateRequest && emailInput.isEmpty
        ? _normalizeEmail(_existingEmail ?? '')
        : emailInput;

    final phoneNumber = isUpdateRequest && phoneNumberInput.isEmpty
        ? _normalizePhoneNumber(_existingPhoneNumber ?? '')
        : phoneNumberInput;

    final effectiveBranchType = isUpdateRequest
        ? (selectedBranchType ?? _existingBranchType)
        : selectedBranchType;

    if (branchName.isEmpty) {
      showError('Please enter branch name');
      return;
    }

    if (email.isEmpty) {
      showError('Please enter email');
      return;
    }

    if (!Validators.isValidSimpleEmail(email)) {
      showError('Invalid email address format');
      return;
    }

    if (phoneNumber.isEmpty) {
      showError('Please enter phone number');
      return;
    }

    if (!Validators.isValidInternationalPhoneNumber(phoneNumber)) {
      showError('Phone number is not valid. Use format like +201012345678');
      return;
    }

    if (effectiveBranchType == null ||
        effectiveBranchType < 0 ||
        effectiveBranchType > 2) {
      showError(
        'Please select a valid gym type (Men Only, Women Only, or Mixed)',
      );
      return;
    }

    if (isUpdateRequest) {
      context.read<CreateBranchCubit>().editBranch(
        branchId: widget.args!.branchId,
        name: branchName,
        email: email,
        phoneNumber: phoneNumber,
        branchType: effectiveBranchType,
      );
      return;
    }

    context.read<CreateBranchCubit>().createBranch(
      name: branchName,
      email: email,
      phoneNumber: phoneNumber,
      branchType: effectiveBranchType,
    );
  }

  String? _pickBestText(String? currentValue, String? newValue) {
    final candidate = newValue?.trim();
    if (candidate == null || candidate.isEmpty) {
      return currentValue;
    }
    return candidate;
  }

  void _applyExistingFromBranchArgs() {
    final branch = widget.args?.branch;
    if (branch == null) return;

    _existingName = branch.name;
    _existingPhoneNumber = branch.phoneNumber;
    _existingEmail = branch.email;
    _existingBranchType = branch.branchType;
  }

  void _applyExistingFromSetupDetails(BranchSetupDetailsEntity details) {
    _existingName = _pickBestText(_existingName, details.businessDetails.name);
    _existingPhoneNumber = _pickBestText(
      _existingPhoneNumber,
      details.businessDetails.phoneNumber,
    );
    _existingEmail = _pickBestText(
      _existingEmail,
      details.businessDetails.email,
    );

    final apiBranchType = details.businessDetails.branchType;
    if (apiBranchType >= 0 && apiBranchType <= 2) {
      _existingBranchType = apiBranchType;
    }

    if (_isEditMode) {
      // In edit mode we intentionally keep user input fields empty and show old values as hints.
      branchNameController.clear();
      phoneNumberController.clear();
      emailController.clear();
    }
  }

  String _normalizeArabicDigits(String value) {
    const arabicIndic = '٠١٢٣٤٥٦٧٨٩';
    const easternArabicIndic = '۰۱۲۳۴۵۶۷۸۹';
    var result = value;
    for (var index = 0; index < 10; index++) {
      result = result
          .replaceAll(arabicIndic[index], '$index')
          .replaceAll(easternArabicIndic[index], '$index');
    }
    return result;
  }

  String _normalizeEmail(String value) {
    return value.trim().toLowerCase();
  }

  String _normalizePhoneNumber(String value) {
    var normalized = _normalizeArabicDigits(value).trim();
    normalized = normalized.replaceAll(RegExp(r'[\s\-\(\)]'), '');

    if (normalized.startsWith('00')) {
      normalized = '+${normalized.substring(2)}';
    }

    if (normalized.startsWith('+')) {
      return normalized;
    }

    if (normalized.startsWith('0') && normalized.length == 11) {
      return '+2$normalized';
    }

    if (normalized.startsWith('20') && normalized.length == 12) {
      return '+$normalized';
    }

    return normalized;
  }
}
