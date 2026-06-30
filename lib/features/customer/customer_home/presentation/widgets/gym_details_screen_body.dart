import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gymbook/core/routes/route_paths.dart';
import 'package:gymbook/core/theme/styles.dart';
import 'package:gymbook/core/utils/url_launcher_util.dart';
import 'package:gymbook/core/widgets/custom_text.dart';
import 'package:gymbook/features/customer/customer_home/data/models/customer_branch_details_model.dart';
import 'package:gymbook/features/customer/customer_home/presentation/cubits/customer_branch_details_cubit/customer_branch_details_cubit.dart';
import 'package:gymbook/features/customer/customer_home/presentation/cubits/customer_branch_details_cubit/customer_branch_details_state.dart';
import 'package:go_router/go_router.dart';
import 'package:gymbook/features/customer/customer_home/presentation/widgets/gym_info_card.dart';
import 'package:gymbook/features/customer/customer_home/presentation/widgets/image_gym_details.dart';
import 'package:gymbook/features/customer/customer_home/presentation/widgets/opening_hours_card.dart';
import 'package:gymbook/features/customer/customer_home/presentation/widgets/subscription_plans_horizontal_list.dart';

class GymDetailsScreenBody extends StatelessWidget {
  final GymDetailsArgs args;

  const GymDetailsScreenBody({super.key, required this.args});

  bool _hasValidCoordinates(CustomerBranchDetailsModel details) {
    final latitude = details.latitude;
    final longitude = details.longitude;
    if (latitude == 0 && longitude == 0) return false;
    return latitude >= -90 &&
        latitude <= 90 &&
        longitude >= -180 &&
        longitude <= 180;
  }

  Future<void> _openDirections(
    BuildContext context,
    CustomerBranchDetailsModel details,
  ) async {
    if (!_hasValidCoordinates(details)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gym location is not available yet')),
      );
      return;
    }

    final launched = await UrlLauncherUtil.launchMap(
      latitude: details.latitude,
      longitude: details.longitude,
    );

    if (!launched && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Unable to open Google Maps')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CustomerBranchDetailsCubit, CustomerBranchDetailsState>(
      builder: (context, state) {
        if (state is CustomerBranchDetailsLoading ||
            state is CustomerBranchDetailsInitial) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is CustomerBranchDetailsError) {
          return Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AppText(
                    state.message,
                    style: font14w500,
                    alignment: AlignmentDirectional.center,
                  ),
                  SizedBox(height: 12.h),
                  ElevatedButton(
                    onPressed: () {
                      context
                          .read<CustomerBranchDetailsCubit>()
                          .loadBranchDetails(args.branchId);
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          );
        }

        if (state is CustomerBranchDetailsLoaded) {
          final details = state.details;

          return SingleChildScrollView(
            child: Column(
              children: [
                ImageGymDetails(images: state.displayImages),
                SizedBox(height: 16.h),
                GymInfoCard(
                  gymName: details.name,
                  rating: details.averageRating,
                  reviewsCount: details.totalRatings,
                  type: details.branchTypeName,
                  address: details.address,
                  onDirectionsTap: () => _openDirections(context, details),
                  onReviewsTap: () async {
                    await context.push(
                      Routes.adminBranchReviewsScreen,
                      extra: {
                        'branchId': args.branchId,
                        'branchName': details.name,
                      },
                    );
                    if (context.mounted) {
                      context
                          .read<CustomerBranchDetailsCubit>()
                          .loadBranchDetails(args.branchId);
                    }
                  },
                ),
                SizedBox(height: 16.h),
                OpeningHoursCard(hours: state.workingHours),
                SizedBox(height: 16.h),
                // const AmenitiesCard(),
                // SizedBox(height: 16.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: AppText(
                    'Membership Plans',
                    style: font18w700.copyWith(color: const Color(0xff2C3E50)),
                  ),
                ),
                SizedBox(height: 16.h),
                SubscriptionPlansHorizontalList(
                  branchId: args.branchId,
                  plans: state.plans,
                ),
                SizedBox(height: 32.h),
              ],
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}

class GymDetailsArgs {
  final int branchId;
  final String gymName;
  final double rating;
  final int reviewsCount;
  final String type;

  const GymDetailsArgs({
    required this.branchId,
    required this.gymName,
    required this.rating,
    required this.reviewsCount,
    required this.type,
  });
}
