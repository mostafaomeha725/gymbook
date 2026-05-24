import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:gymbook/core/di/services_locator.dart';
import 'package:gymbook/core/constants/app_assets.dart';
import 'package:gymbook/core/network/endpoints.dart';
import 'package:gymbook/core/network/network_service.dart';
import 'package:gymbook/core/theme/styles.dart';
import 'package:gymbook/core/widgets/custom_text.dart';
import 'package:gymbook/features/customer/customer_home/data/models/customer_branch_details_model.dart';
import 'package:gymbook/features/customer/customer_home/presentation/widgets/amenities_card.dart';
import 'package:gymbook/features/customer/customer_home/presentation/widgets/gym_info_card.dart';
import 'package:gymbook/features/customer/customer_home/presentation/widgets/image_gym_details.dart';
import 'package:gymbook/features/customer/customer_home/presentation/widgets/opening_hours_card.dart';
import 'package:gymbook/features/customer/customer_home/presentation/widgets/subscription_plan_card.dart';
import 'package:gymbook/features/customer/customer_home/presentation/widgets/subscription_plans_horizontal_list.dart';

class GymDetailsScreenBody extends StatefulWidget {
  final GymDetailsArgs args;

  const GymDetailsScreenBody({super.key, required this.args});

  @override
  State<GymDetailsScreenBody> createState() => _GymDetailsScreenBodyState();
}

class _GymDetailsScreenBodyState extends State<GymDetailsScreenBody> {
  late Future<CustomerBranchDetailsModel> _detailsFuture;

  bool _hasValidCoordinates(CustomerBranchDetailsModel details) {
    final latitude = details.latitude;
    final longitude = details.longitude;
    if (latitude == 0 && longitude == 0) return false;
    return latitude >= -90 &&
        latitude <= 90 &&
        longitude >= -180 &&
        longitude <= 180;
  }

  Future<void> _openDirections(CustomerBranchDetailsModel details) async {
    if (!_hasValidCoordinates(details)) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gym location is not available yet')),
      );
      return;
    }

    final destination = '${details.latitude},${details.longitude}';
    final appUri = Uri.parse('google.navigation:q=$destination&mode=d');
    final webUri = Uri.parse(
      'https://www.google.com/maps/dir/?api=1&destination=$destination&travelmode=driving',
    );

    var launched = await launchUrl(
      appUri,
      mode: LaunchMode.externalApplication,
    );

    if (!launched) {
      launched = await launchUrl(webUri, mode: LaunchMode.externalApplication);
    }

    if (!launched && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Unable to open Google Maps')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _detailsFuture = _loadDetails();
  }

  Future<CustomerBranchDetailsModel> _loadDetails() async {
    final networkService = sl<NetworkService>();
    final response = await networkService.getData(
      endPoint: EndPoints.getBranchDetails(widget.args.branchId),
    );

    return response.fold(
      (failure) => throw Exception(failure.message),
      (data) =>
          CustomerBranchDetailsModel.fromJson(data as Map<String, dynamic>),
    );
  }

  String _formatTime(String value) {
    if (value.trim().isEmpty) return '--:--';
    final split = value.split(':');
    if (split.length < 2) return value;
    return '${split[0].padLeft(2, '0')}:${split[1].padLeft(2, '0')}';
  }

  List<WorkingHourViewModel> _mapWorkingHours(
    List<CustomerWorkingHourModel> workingHours,
  ) {
    const dayNames = {
      0: 'Sunday',
      1: 'Monday',
      2: 'Tuesday',
      3: 'Wednesday',
      4: 'Thursday',
      5: 'Friday',
      6: 'Saturday',
    };

    final mapped =
        workingHours
            .map(
              (item) => WorkingHourViewModel(
                dayName: dayNames[item.day] ?? 'Day ${item.day}',
                hoursLabel: item.isClosed
                    ? 'Closed'
                    : '${_formatTime(item.openTime)} - ${_formatTime(item.closeTime)}',
                dayIndex: item.day,
              ),
            )
            .toList()
          ..sort((a, b) => a.dayIndex.compareTo(b.dayIndex));

    return mapped;
  }

  List<PlanModel> _mapPlans(List<CustomerPackageModel> packages) {
    return packages
        .map(
          (item) => PlanModel(
            title: item.name,
            price: item.price,
            duration:
                '${item.durationInMonths} month${item.durationInMonths == 1 ? '' : 's'}',
          ),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<CustomerBranchDetailsModel>(
      future: _detailsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AppText(
                    snapshot.error.toString().replaceFirst('Exception: ', ''),
                    style: font14w500,
                    alignment: AlignmentDirectional.center,
                  ),
                  SizedBox(height: 12.h),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _detailsFuture = _loadDetails();
                      });
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          );
        }

        final details = snapshot.data;
        if (details == null) {
          return const SizedBox.shrink();
        }

        final images = details.images
            .map((item) => item.url)
            .where((url) => url.trim().isNotEmpty)
            .toList();
        final displayImages = images.isEmpty
            ? <String>[Assets.gym3, Assets.gym2, Assets.gym3]
            : images;

        final workingHours = _mapWorkingHours(details.workingHours);
        final plans = _mapPlans(details.packages);

        return SingleChildScrollView(
          child: Column(
            children: [
              ImageGymDetails(images: displayImages),
              SizedBox(height: 16.h),
              GymInfoCard(
                gymName: details.name,
                rating: details.averageRating,
                reviewsCount: details.totalRatings,
                type: details.branchTypeName,
                address: details.address,
                onDirectionsTap: () => _openDirections(details),
              ),
              SizedBox(height: 16.h),

              OpeningHoursCard(hours: workingHours),
              SizedBox(height: 16.h),

              const AmenitiesCard(),
              SizedBox(height: 16.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: AppText(
                  'Membership Plans',
                  style: font18w700.copyWith(color: const Color(0xff2C3E50)),
                ),
              ),
              SizedBox(height: 16.h),
              SubscriptionPlansHorizontalList(plans: plans),
              SizedBox(height: 32.h),
            ],
          ),
        );
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
