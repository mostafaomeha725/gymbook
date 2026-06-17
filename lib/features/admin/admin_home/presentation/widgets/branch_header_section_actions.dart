part of 'branch_header_section.dart';

extension _BranchHeaderSectionActions on _BranchHeaderSectionState {
  Future<void> _updateStatus(bool value) async {
    _updateState(() => isActive = value);

    showLoading();
    final result = await sl<BranchRepository>().updateBranchStatus(
      branchId: widget.branch.id,
      branchStatus: value ? 1 : 2,
    );
    hideLoading();

    result.fold((failure) {
      _updateState(() => isActive = !value);
      showError(failure.message);
    }, (_) {});
  }

  String _firstDetailsUrl(List<BranchImageEntity> images, int type) {
    for (final image in images) {
      final url = image.url.trim();
      if (image.type == type && url.isNotEmpty) {
        return url;
      }
    }
    return '';
  }

  String _firstSetupUrl(BranchSetupState setupState, int type) {
    final details = setupState.details;
    if (details == null) return '';

    final images = [...details.images]
      ..sort((a, b) => a.displayOrder.compareTo(b.displayOrder));

    for (final image in images) {
      final url = image.url.trim();
      if (image.type == type && url.isNotEmpty) {
        return url;
      }
    }
    return '';
  }

  List<String> _setupGalleryUrls(BranchSetupState setupState) {
    final details = setupState.details;
    if (details == null) return const <String>[];

    final images = [...details.images]
      ..sort((a, b) => a.displayOrder.compareTo(b.displayOrder));

    return images
        .map((image) => image.url.trim())
        .where((url) => url.isNotEmpty)
        .toList();
  }

  int _resolveSelectedIndex(int total) {
    if (total <= 0) return 0;
    if (_selectedGalleryIndex < 0 || _selectedGalleryIndex >= total) {
      return 0;
    }
    return _selectedGalleryIndex;
  }

  void _selectGalleryImage(int index, int total) {
    if (total <= 0) return;
    if (index < 0 || index >= total) return;
    _updateState(() => _selectedGalleryIndex = index);
  }

  void _showPreviousImage(int currentIndex, int total) {
    if (total <= 0) return;
    int nextIndex = currentIndex - 1;
    if (nextIndex < 0) nextIndex = total - 1;
    _updateState(() => _selectedGalleryIndex = nextIndex);
  }

  void _showNextImage(int currentIndex, int total) {
    if (total <= 0) return;
    int nextIndex = currentIndex + 1;
    if (nextIndex >= total) nextIndex = 0;
    _updateState(() => _selectedGalleryIndex = nextIndex);
  }
}
