import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gymbook/core/theme/styles.dart';
import 'package:gymbook/core/widgets/custom_text.dart';
import 'package:gymbook/core/utils/easy_loading.dart';
import 'package:gymbook/features/customer/customer_home/domain/entities/nearby_branch_entity.dart';
import 'package:gymbook/features/customer/customer_home/presentation/cubits/nearby_branches_cubit/nearby_branches_cubit.dart';
import 'package:gymbook/features/customer/customer_home/presentation/widgets/gym_card.dart';
import 'package:gymbook/features/customer/customer_home/presentation/widgets/gym_pagination_widget.dart';

class NearbyGymsSection extends StatelessWidget {
  final bool showOnlyOpenGyms;
  final ValueChanged<NearbyBranchEntity> onGymTap;

  const NearbyGymsSection({
    super.key,
    required this.showOnlyOpenGyms,
    required this.onGymTap,
  });

  String _formatDistance(int meters) {
    if (meters >= 1000) {
      return '${(meters / 1000).toStringAsFixed(1)} km';
    }
    return '$meters m';
  }

  Widget _buildGymCard(NearbyBranchEntity gym) {
    return GymCard(
      gymName: gym.name,
      imageUrl: gym.logoUrl,
      type: gym.branchTypeName,
      rating: gym.averageRating,
      reviewsCount: gym.totalRatings,
      isOpen: gym.isOpenNow,
      distance: gym.hasDistance ? _formatDistance(gym.distanceInMeters) : '—',
      onTap: () => onGymTap(gym),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<NearbyBranchesCubit, NearbyBranchesState>(
      listener: (context, state) {
        if (state is NearbyBranchesSuccess || state is NearbyBranchesFailure) {
          hideLoading();
        }
      },
      child: BlocBuilder<NearbyBranchesCubit, NearbyBranchesState>(
        builder: (context, state) {
          if (state is NearbyBranchesLoading) {
            return Padding(
              padding: EdgeInsets.symmetric(vertical: 60.h),
              child: const Center(child: CircularProgressIndicator()),
            );
          }

          if (state is NearbyBranchesFailure) {
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
              child: Column(
                children: [
                  AppText(
                    state.message,
                    style: font14w500.copyWith(color: const Color(0xff4A5565)),
                    alignment: AlignmentDirectional.center,
                  ),
                  SizedBox(height: 12.h),
                  ElevatedButton(
                    onPressed: () {
                      context.read<NearbyBranchesCubit>().loadNearby();
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (state is! NearbyBranchesSuccess) {
            return const SizedBox.shrink();
          }

          final response = state.response;
          final gyms = showOnlyOpenGyms
              ? response.data.where((gym) => gym.isOpenNow).toList()
              : response.data;

          return Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AppText('Nearby Gyms', style: font20w700),
                    AppText(
                      '${response.totalCount} gyms found',
                      style: font14w400.copyWith(
                        color: const Color(0xff4A5565),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16.h),
              if (gyms.isEmpty)
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 30.h),
                  child: AppText(
                    showOnlyOpenGyms
                        ? 'No open gyms found'
                        : 'No gyms found for this location',
                    style: font14w500.copyWith(color: const Color(0xff4A5565)),
                    alignment: AlignmentDirectional.center,
                  ),
                )
              else
                ...gyms.map(_buildGymCard),
              if (response.totalPages > 1)
                GymPaginationWidget(
                  totalPages: response.totalPages,
                  currentPage: response.currentPage,
                  onPageChanged: (page) {
                    showLoading();
                    context.read<NearbyBranchesCubit>().loadNearby(
                      pageNumber: page,
                    );
                  },
                ),
            ],
          );
        },
      ),
    );
  }
}
