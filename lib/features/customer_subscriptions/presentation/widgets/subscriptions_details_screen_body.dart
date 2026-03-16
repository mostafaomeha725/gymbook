import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gymbook/core/di/services_locator.dart';
import 'package:gymbook/core/constants/app_assets.dart';
import 'package:gymbook/core/network/endpoints.dart';
import 'package:gymbook/core/network/network_service.dart';
import 'package:gymbook/features/customer_subscriptions/data/models/customer_subscription_details_model.dart';
import 'package:gymbook/features/customer_subscriptions/presentation/screens/subscriptions_details_screen.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:gymbook/features/customer_subscriptions/presentation/widgets/attendance_history_card.dart';
import 'package:gymbook/features/customer_subscriptions/presentation/widgets/rating_card.dart';
import 'package:gymbook/features/customer_subscriptions/presentation/widgets/subscriptions_details_info_card.dart';
import 'package:gymbook/features/customer_subscriptions/presentation/widgets/subscriptions_info_card.dart';
import 'package:gymbook/features/customer_home/presentation/widgets/image_gym_details.dart';

class SubscriptionsDetailsScreenBody extends StatefulWidget {
  final CustomerSubscriptionDetailsArgs args;

  const SubscriptionsDetailsScreenBody({super.key, required this.args});

  @override
  State<SubscriptionsDetailsScreenBody> createState() =>
      _SubscriptionsDetailsScreenBodyState();
}

class _SubscriptionsDetailsScreenBodyState
    extends State<SubscriptionsDetailsScreenBody> {
  late Future<CustomerSubscriptionDetailsModel> _detailsFuture;
  int? _statusOverride;

  @override
  void initState() {
    super.initState();
    _detailsFuture = _loadDetails();
  }

  Future<CustomerSubscriptionDetailsModel> _loadDetails() async {
    final networkService = sl<NetworkService>();
    final response = await networkService.getData(
      endPoint: EndPoints.getMySubscriptionDetails(widget.args.subscriptionId),
    );

    return response.fold(
      (failure) => throw Exception(failure.message),
      (data) => CustomerSubscriptionDetailsModel.fromJson(
        data as Map<String, dynamic>,
      ),
    );
  }

  bool _hasValidCoordinates(CustomerSubscriptionDetailsModel details) {
    if (details.latitude == null || details.longitude == null) return false;
    final latitude = details.latitude!;
    final longitude = details.longitude!;
    if (latitude == 0 && longitude == 0) return false;
    return latitude >= -90 &&
        latitude <= 90 &&
        longitude >= -180 &&
        longitude <= 180;
  }

  Future<void> _openGoogleMaps(CustomerSubscriptionDetailsModel details) async {
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
  Widget build(BuildContext context) {
    return FutureBuilder<CustomerSubscriptionDetailsModel>(
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
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    snapshot.error.toString().replaceFirst('Exception: ', ''),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 12.h),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _statusOverride = null;
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

        final currentStatus = _statusOverride ?? details.subscriptionStatus;

        return SingleChildScrollView(
          child: Column(
            children: [
              ImageGymDetails(images: displayImages),
              SizedBox(height: 16.h),
              SubscriptionsInfoCard(
                gymName: details.branchName,
                address: details.address,
                status: currentStatus,
                onViewOnMapTap: () => _openGoogleMaps(details),
              ),
              SizedBox(height: 16.h),
              SubscriptionsDetailsInfoCard(
                subscriptionId: details.subscriptionId,
                status: currentStatus,
                packageName: details.packageName,
                price: details.price,
                activationDate: details.activationDate,
                endDate: details.endDate,
                checkInsCount: details.checkInsCount,
                durationInDays: details.durationInDays,
                onStatusChanged: (newStatus) {
                  setState(() {
                    _statusOverride = newStatus;
                  });
                },
              ),
              SizedBox(height: 16.h),
              const AttendanceHistoryCard(),
              SizedBox(height: 16.h),
              const RatingCard(),
              SizedBox(height: 64.h),
            ],
          ),
        );
      },
    );
  }
}
