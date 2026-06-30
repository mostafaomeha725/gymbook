import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gymbook/features/customer/customer_home/presentation/cubits/nearby_branches_cubit/nearby_branches_cubit.dart';
import 'package:gymbook/features/customer/customer_home/presentation/models/saved_location.dart';
import 'package:gymbook/features/customer/customer_home/presentation/services/customer_home_location_actions.dart';
import 'package:gymbook/features/customer/customer_home/presentation/services/home_location_preferences.dart';
import 'package:gymbook/features/customer/customer_home/presentation/widgets/customer_home_screen_body.dart';

/// Mixin to handle all location-related logic for CustomerHomeScreenBody
/// Separates the logic from the UI without changing functionality.
mixin CustomerHomeLocationMixin on State<CustomerHomeScreenBody> {
  String locationLabel = 'Tap to choose location';
  List<SavedLocation> savedLocations = const [];
  String? selectedLocationId;

  final HomeLocationPreferences locationPreferences = HomeLocationPreferences();
  final CustomerHomeLocationActions locationActions =
      CustomerHomeLocationActions();

  String fallbackLocationLabel(double latitude, double longitude) =>
      'Lat ${latitude.toStringAsFixed(4)}, Lng ${longitude.toStringAsFixed(4)}';

  Future<void> restoreLocationsAndLoad() async {
    final cubit = context.read<NearbyBranchesCubit>();
    final locationPrefsState = await locationPreferences.load();

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
      savedLocations = locationPrefsState.savedLocations;
      selectedLocationId = selected?.id;
      if (selected != null) {
        locationLabel = selected.label;
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

  Future<void> applyLocation({
    required double latitude,
    required double longitude,
    String? resolvedAddress,
  }) async {
    final location = SavedLocation(
      id: SavedLocation.buildId(latitude, longitude),
      label: (resolvedAddress != null && resolvedAddress.trim().isNotEmpty)
          ? resolvedAddress.trim()
          : fallbackLocationLabel(latitude, longitude),
      latitude: latitude,
      longitude: longitude,
    );

    final updated = List<SavedLocation>.from(savedLocations);
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
      savedLocations = updated;
      selectedLocationId = location.id;
      locationLabel = location.label;
    });

    await locationPreferences.save(
      savedLocations: updated,
      selectedLocationId: location.id,
    );
    if (!mounted) return;
    await context.read<NearbyBranchesCubit>().setLocation(
      latitude: latitude,
      longitude: longitude,
    );
  }

  Future<void> selectSavedLocation(SavedLocation location) {
    return applyLocation(
      latitude: location.latitude,
      longitude: location.longitude,
      resolvedAddress: location.label,
    );
  }

  Future<void> openLocationPicker() async {
    await locationActions.openLocationPicker(
      context: context,
      savedLocations: savedLocations,
      selectedLocationId: selectedLocationId,
      onSelectSaved: selectSavedLocation,
      onUseCurrentLocation: useCurrentLocation,
      onChooseFromMap: useMapLocation,
    );
  }

  Future<void> useCurrentLocation() {
    return locationActions.useCurrentLocation(
      context: context,
      onLocationResolved: applyLocation,
    );
  }

  Future<void> useMapLocation() {
    return locationActions.useMapLocation(
      context: context,
      onLocationResolved: applyLocation,
    );
  }
}
