import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:gymbook/core/di/services_locator.dart';
import 'package:gymbook/core/utils/easy_loading.dart';
import 'package:gymbook/features/admin/admin_home/domain/entities/branch_details_entity.dart';
import 'package:gymbook/features/admin/admin_home/domain/entities/branch_entity.dart';
import 'package:gymbook/features/admin/admin_home/domain/repositories/branch_repository.dart';
import 'package:gymbook/features/admin/admin_home/presentation/cubits/branch_details_cubit/branch_details_cubit.dart';
import 'package:gymbook/features/admin/admin_home/presentation/cubits/branch_setup_cubit/branch_setup_cubit.dart';
import 'package:gymbook/features/admin/admin_home/presentation/widgets/branch_header_section_content.dart';

part 'branch_header_section_actions.dart';

class BranchHeaderSection extends StatefulWidget {
  final BranchEntity branch;

  const BranchHeaderSection({super.key, required this.branch});

  @override
  State<BranchHeaderSection> createState() => _BranchHeaderSectionState();
}

class _BranchHeaderSectionState extends State<BranchHeaderSection> {
  static const String _placeholderImage =
      'https://images.unsplash.com/photo-1506744038136-46273834b3fb';

  late bool isActive;
  int _selectedGalleryIndex = 0;

  @override
  void initState() {
    super.initState();
    isActive = widget.branch.branchStatus == 1;
  }

  void _updateState(VoidCallback changes) {
    setState(changes);
  }

  @override
  Widget build(BuildContext context) {
    final branch = widget.branch;

    return BlocBuilder<BranchDetailsCubit, BranchDetailsState>(
      builder: (context, detailsState) {
        final detailsImages = detailsState is BranchDetailsSuccess
            ? detailsState.response.images
            : const <BranchImageEntity>[];

        return BlocBuilder<BranchSetupCubit, BranchSetupState>(
          builder: (context, setupState) {
            final setupLogo = _firstSetupUrl(setupState, 0);
            final setupMarketplace = _firstSetupUrl(setupState, 1);
            final detailsLogo = _firstDetailsUrl(detailsImages, 0);
            final detailsMarketplace = _firstDetailsUrl(detailsImages, 1);

            final coverUrl = setupMarketplace.isNotEmpty
                ? setupMarketplace
                : detailsMarketplace.isNotEmpty
                ? detailsMarketplace
                : setupLogo.isNotEmpty
                ? setupLogo
                : detailsLogo.isNotEmpty
                ? detailsLogo
                : _placeholderImage;

            final avatarUrl = setupLogo.isNotEmpty
                ? setupLogo
                : detailsLogo.isNotEmpty
                ? detailsLogo
                : (branch.logo ??
                      'https://randomuser.me/api/portraits/men/32.jpg');

            final galleryUrls = _setupGalleryUrls(setupState);
            final selectedIndex = _resolveSelectedIndex(galleryUrls.length);
            final displayedCoverUrl = galleryUrls.isNotEmpty
                ? galleryUrls[selectedIndex]
                : coverUrl;

            return BranchHeaderSectionContent(
              branch: branch,
              displayedCoverUrl: displayedCoverUrl,
              avatarUrl: avatarUrl,
              isActive: isActive,
              onStatusChanged: _updateStatus,
              onBackTap: () => GoRouter.of(context).pop(),
              galleryUrls: galleryUrls,
              selectedIndex: selectedIndex,
              onPreviousTap: galleryUrls.length > 1
                  ? () => _showPreviousImage(selectedIndex, galleryUrls.length)
                  : null,
              onNextTap: galleryUrls.length > 1
                  ? () => _showNextImage(selectedIndex, galleryUrls.length)
                  : null,
              onSelectImage: (index) =>
                  _selectGalleryImage(index, galleryUrls.length),
            );
          },
        );
      },
    );
  }
}
