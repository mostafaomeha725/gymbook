import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:gymbook/core/routes/route_paths.dart';
import 'package:gymbook/features/customer/customer_home/presentation/cubits/nearby_branches_cubit/nearby_branches_cubit.dart';
import 'package:gymbook/core/cache/preferences_storage.dart';
import 'package:gymbook/core/di/services_locator.dart';
import 'package:gymbook/features/customer/customer_home/presentation/widgets/appbar_home_widget.dart';
import 'package:gymbook/features/customer/customer_home/presentation/widgets/gym_details_screen_body.dart';
import 'package:gymbook/features/customer/customer_home/presentation/widgets/nearby_gyms_section.dart';
import 'package:gymbook/features/customer/customer_home/presentation/widgets/mixins/customer_home_location_mixin.dart';

class CustomerHomeScreenBody extends StatefulWidget {
  const CustomerHomeScreenBody({super.key});

  @override
  State<CustomerHomeScreenBody> createState() => _CustomerHomeScreenBodyState();
}

class _CustomerHomeScreenBodyState extends State<CustomerHomeScreenBody>
    with WidgetsBindingObserver, CustomerHomeLocationMixin {
  String _userName = 'Guest';
  final bool _showOnlyOpenGyms = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    final name = sl<PreferencesStorage>().getUserName();
    if (name != null && name.isNotEmpty) {
      _userName = name;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;
      restoreLocationsAndLoad();
      await checkAndShowLocationSheet();
    });
  }

  void _goToDetails({
    required int branchId,
    required String gymName,
    required double rating,
    required int reviewsCount,
    required String type,
  }) {
    GoRouter.of(context).push(
      Routes.gymDetailsScreen,
      extra: GymDetailsArgs(
        branchId: branchId,
        gymName: gymName,
        rating: rating,
        reviewsCount: reviewsCount,
        type: type,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: SingleChildScrollView(
        child: Column(
          children: [
            AppbarHomeWidget(
              userName: _userName,
              location: locationLabel,
              onLocationTap: openLocationPicker,
              onSearchChanged: (value) {
                context.read<NearbyBranchesCubit>().loadNearby(search: value);
              },
            ),

            // SizedBox(height: 16.h),
            // ShowOnlyOpenGymsCard(
            //   initialValue: _showOnlyOpenGyms,
            //   onChanged: (value) {
            //     setState(() {
            //       _showOnlyOpenGyms = value;
            //     });
            //   },
            // ),
            SizedBox(height: 24.h),

            NearbyGymsSection(
              showOnlyOpenGyms: _showOnlyOpenGyms,
              onGymTap: (gym) => _goToDetails(
                branchId: gym.id,
                gymName: gym.name,
                rating: gym.averageRating,
                reviewsCount: gym.totalRatings,
                type: gym.branchTypeName,
              ),
            ),

            SizedBox(height: 132.h),
          ],
        ),
      ),
    );
  }
}
