import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:gymbook/core/routes/route_paths.dart';
import 'package:gymbook/features/customer_home/presentation/cubits/nearby_branches_cubit/nearby_branches_cubit.dart';
import 'package:gymbook/features/customer_home/presentation/models/saved_location.dart';
import 'package:gymbook/features/customer_home/presentation/services/customer_home_location_actions.dart';
import 'package:gymbook/features/customer_home/presentation/services/home_location_preferences.dart';
import 'package:gymbook/features/customer_home/presentation/widgets/appbar_home_widget.dart';
import 'package:gymbook/features/customer_home/presentation/widgets/gym_details_screen_body.dart';
import 'package:gymbook/features/customer_home/presentation/widgets/nearby_gyms_section.dart';

class CustomerHomeScreenBody extends StatefulWidget {
  const CustomerHomeScreenBody({super.key});

  @override
  State<CustomerHomeScreenBody> createState() => _CustomerHomeScreenBodyState();
}

class _CustomerHomeScreenBodyState extends State<CustomerHomeScreenBody> {
  String _locationLabel = 'Tap to choose location';
  bool _showOnlyOpenGyms = false;
  List<SavedLocation> _savedLocations = const [];
  String? _selectedLocationId;
  final HomeLocationPreferences _locationPreferences =
      HomeLocationPreferences();
  final CustomerHomeLocationActions _locationActions =
      CustomerHomeLocationActions();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _restoreLocationsAndLoad();
    });
  }

  String _fallbackLocationLabel(double latitude, double longitude) =>
      'Lat ${latitude.toStringAsFixed(4)}, Lng ${longitude.toStringAsFixed(4)}';

  Future<void> _restoreLocationsAndLoad() async {
    final cubit = context.read<NearbyBranchesCubit>();
    final locationPrefsState = await _locationPreferences.load();

    SavedLocation? selected;
    if (locationPrefsState.selectedLocationId != null) {
      for (final location in locationPrefsState.savedLocations) {
        if (location.id == locationPrefsState.selectedLocationId) {
          selected = location;
          break;
        }
      }
    }

    if (!mounted) return;
    setState(() {
      _savedLocations = locationPrefsState.savedLocations;
      _selectedLocationId = selected?.id;
      if (selected != null) {
        _locationLabel = selected!.label;
      }
    });

    if (selected != null) {
      await cubit.setLocation(
        latitude: selected.latitude,
        longitude: selected.longitude,
      );
      return;
    }

    await cubit.loadNearby();
  }

  Future<void> _applyLocation({
    required double latitude,
    required double longitude,
    String? resolvedAddress,
  }) async {
    final location = SavedLocation(
      id: SavedLocation.buildId(latitude, longitude),
      label: (resolvedAddress != null && resolvedAddress.trim().isNotEmpty)
          ? resolvedAddress.trim()
          : _fallbackLocationLabel(latitude, longitude),
      latitude: latitude,
      longitude: longitude,
    );

    final updated = List<SavedLocation>.from(_savedLocations);
    updated.removeWhere((item) => item.id == location.id);
    updated.insert(0, location);
    if (updated.length > HomeLocationPreferences.maxSavedLocations) {
      updated.removeRange(
        HomeLocationPreferences.maxSavedLocations,
        updated.length,
      );
    }

    if (!mounted) return;
    setState(() {
      _savedLocations = updated;
      _selectedLocationId = location.id;
      _locationLabel = location.label;
    });

    await _locationPreferences.save(
      savedLocations: updated,
      selectedLocationId: location.id,
    );
    if (!mounted) return;
    await context.read<NearbyBranchesCubit>().setLocation(
      latitude: latitude,
      longitude: longitude,
    );
  }

  Future<void> _selectSavedLocation(SavedLocation location) {
    return _applyLocation(
      latitude: location.latitude,
      longitude: location.longitude,
      resolvedAddress: location.label,
    );
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

  Future<void> _openLocationPicker() async {
    await _locationActions.openLocationPicker(
      context: context,
      savedLocations: _savedLocations,
      selectedLocationId: _selectedLocationId,
      onSelectSaved: _selectSavedLocation,
      onUseCurrentLocation: _useCurrentLocation,
      onChooseFromMap: _useMapLocation,
    );
  }

  Future<void> _useCurrentLocation() {
    return _locationActions.useCurrentLocation(
      context: context,
      onLocationResolved: _applyLocation,
    );
  }

  Future<void> _useMapLocation() {
    return _locationActions.useMapLocation(
      context: context,
      onLocationResolved: _applyLocation,
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
              userName: 'Ahmed',
              location: _locationLabel,
              onLocationTap: _openLocationPicker,
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
