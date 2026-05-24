part of 'all_text_field_add_branch_two.dart';

extension _AllTextFieldAddBranchTwoActions on _AllTextFieldAddBranchTwoState {
  void _applyFromBranchArgs() {
    final branch = widget.args?.branch;
    if (branch == null) return;

    addresscontroller.text = branch.address ?? '';
    selectedGovernorate = branch.governorate?.name;
    selectedGovernorateId = branch.governorate?.id;
    selectedLatitude = branch.latitude;
    selectedLongitude = branch.longitude;
  }

  void _applyFromSetupDetails(BranchSetupDetailsEntity details) {
    addresscontroller.text = details.location.address;
    selectedGovernorate = details.location.governorate?.name;
    selectedGovernorateId = details.location.governorate?.id;
    selectedLatitude = details.location.coordinates.latitude;
    selectedLongitude = details.location.coordinates.longitude;
  }

  void _submit() {
    context.read<BranchLocationCubit>().submitLocationDetails(
      branchId: widget.branchId,
      governorateId: selectedGovernorateId,
      address: addresscontroller.text,
      latitude: selectedLatitude,
      longitude: selectedLongitude,
    );
  }

  List<GovernorateDropdownItem> _governorateItemsFromState(
    GovernoratesState state,
  ) {
    if (state is GovernoratesLoaded) {
      return state.governorates
          .map((item) => GovernorateDropdownItem(id: item.id, name: item.name))
          .toList();
    }
    return const [];
  }
}
