import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gymbook/core/di/services_locator.dart';
import 'package:gymbook/core/constants/app_assets.dart';
import 'package:gymbook/features/customer/customer_subscriptions/domain/entities/customer_subscription_details_entity.dart';
import 'package:gymbook/features/customer/customer_subscriptions/presentation/cubits/customer_subscription_details_cubit/customer_subscription_details_cubit.dart';
import 'package:gymbook/features/customer/customer_subscriptions/presentation/cubits/customer_subscription_details_cubit/customer_subscription_details_state.dart';
import 'package:gymbook/features/customer/customer_subscriptions/presentation/screens/subscriptions_details_screen.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:gymbook/features/customer/customer_subscriptions/presentation/widgets/attendance_history_card.dart';
import 'package:gymbook/features/customer/customer_subscriptions/presentation/widgets/subscriptions_details_info_card.dart';
import 'package:gymbook/features/customer/customer_subscriptions/presentation/widgets/subscriptions_info_card.dart';
import 'package:gymbook/features/customer/customer_home/presentation/widgets/image_gym_details.dart';

class SubscriptionsDetailsScreenBody extends StatefulWidget {
  final CustomerSubscriptionDetailsArgs args;

  const SubscriptionsDetailsScreenBody({super.key, required this.args});

  @override
  State<SubscriptionsDetailsScreenBody> createState() =>
      _SubscriptionsDetailsScreenBodyState();
}

class _SubscriptionsDetailsScreenBodyState
    extends State<SubscriptionsDetailsScreenBody> {
  late final CustomerSubscriptionDetailsCubit _detailsCubit;
  int? _statusOverride;

  @override
  void initState() {
    super.initState();
    _detailsCubit = sl<CustomerSubscriptionDetailsCubit>()
      ..loadDetails(subscriptionId: widget.args.subscriptionId);
  }

  @override
  void dispose() {
    _detailsCubit.close();
    super.dispose();
  }

  bool _hasValidCoordinates(CustomerSubscriptionDetailsEntity details) {
    if (details.latitude == null || details.longitude == null) return false;
    final latitude = details.latitude!;
    final longitude = details.longitude!;
    if (latitude == 0 && longitude == 0) return false;
    return latitude >= -90 &&
        latitude <= 90 &&
        longitude >= -180 &&
        longitude <= 180;
  }

  Future<void> _openGoogleMaps(
    CustomerSubscriptionDetailsEntity details,
  ) async {
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
    return BlocProvider.value(
      value: _detailsCubit,
      child:
          BlocBuilder<
            CustomerSubscriptionDetailsCubit,
            CustomerSubscriptionDetailsState
          >(
            builder: (context, state) {
              if (state is CustomerSubscriptionDetailsLoading ||
                  state is CustomerSubscriptionDetailsInitial) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state is CustomerSubscriptionDetailsFailure) {
                return Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24.w),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(state.message, textAlign: TextAlign.center),
                        SizedBox(height: 12.h),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _statusOverride = null;
                            });
                            context
                                .read<CustomerSubscriptionDetailsCubit>()
                                .loadDetails(
                                  subscriptionId: widget.args.subscriptionId,
                                );
                          },
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  ),
                );
              }

              if (state is! CustomerSubscriptionDetailsSuccess) {
                return const SizedBox.shrink();
              }

              final details = state.details;

              final images = details.images
                  .map((item) => item.url)
                  .where((url) => url.trim().isNotEmpty)
                  .toList();
              final displayImages = images.isEmpty
                  ? <String>[Assets.gym3, Assets.gym2, Assets.gym3]
                  : images;

              final currentStatus =
                  _statusOverride ?? details.subscriptionStatus;

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
                    AttendanceHistoryCard(
                      subscriptionId: details.subscriptionId,
                    ),
                    // SizedBox(height: 16.h),
                    // RatingCard(branchId: details.branchId),
                    SizedBox(height: 64.h),
                  ],
                ),
              );
            },
          ),
    );
  }
}
