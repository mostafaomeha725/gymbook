part of 'branch_setup_cubit.dart';

class BranchSetupState {
  final bool isEditMode;
  final bool isLoading;
  final BranchSetupDetailsEntity? details;
  final String? errorMessage;

  const BranchSetupState({
    this.isEditMode = false,
    this.isLoading = false,
    this.details,
    this.errorMessage,
  });

  bool get hasData => details != null;

  BranchSetupState copyWith({
    bool? isEditMode,
    bool? isLoading,
    BranchSetupDetailsEntity? details,
    bool clearDetails = false,
    String? errorMessage,
    bool clearError = false,
  }) {
    return BranchSetupState(
      isEditMode: isEditMode ?? this.isEditMode,
      isLoading: isLoading ?? this.isLoading,
      details: clearDetails ? null : (details ?? this.details),
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}
