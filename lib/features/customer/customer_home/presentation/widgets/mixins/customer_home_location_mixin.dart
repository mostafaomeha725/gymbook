import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:gymbook/core/cache/preferences_storage.dart';
import 'package:gymbook/features/customer/customer_home/presentation/cubits/nearby_branches_cubit/nearby_branches_cubit.dart';
import 'package:gymbook/features/customer/customer_home/presentation/models/saved_location.dart';
import 'package:gymbook/features/customer/customer_home/presentation/services/customer_home_location_actions.dart';
import 'package:gymbook/features/customer/customer_home/presentation/services/home_location_preferences.dart';
import 'package:gymbook/features/customer/customer_home/presentation/widgets/customer_home_screen_body.dart';
import 'package:gymbook/core/widgets/location_permission_sheet.dart';
import 'package:gymbook/features/notifications/presentation/cubits/notifications_cubit/notifications_cubit.dart';
import 'package:gymbook/core/di/services_locator.dart';

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
      onClearLocation: savedLocations.isNotEmpty ? clearLocation : null,
      onDeleteLocation: deleteLocation,
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

  Future<void> clearLocation() async {
    // Clear all saved locations
    await locationPreferences.save(
      savedLocations: [],
      selectedLocationId: null,
    );

    if (!mounted) return;
    setState(() {
      savedLocations = [];
      selectedLocationId = null;
      locationLabel = 'Tap to choose location';
    });

    // Reload nearby branches without a location filter
    if (!mounted) return;
    await context.read<NearbyBranchesCubit>().clearLocation();
  }

  Future<void> deleteLocation(SavedLocation location) async {
    final updated = List<SavedLocation>.from(savedLocations);
    updated.removeWhere((l) => l.id == location.id);

    final isDeletingSelected = location.id == selectedLocationId;
    final newSelectedId = isDeletingSelected ? null : selectedLocationId;

    await locationPreferences.save(
      savedLocations: updated,
      selectedLocationId: newSelectedId,
    );

    if (!mounted) return;
    setState(() {
      savedLocations = updated;
      selectedLocationId = newSelectedId;
      if (isDeletingSelected) {
        locationLabel = 'Tap to choose location';
      }
    });

    if (isDeletingSelected) {
      if (!mounted) return;
      await context.read<NearbyBranchesCubit>().clearLocation();
    }
  }

  static bool _hasPromptedLocationThisSession = false;

  /// Checks location permission/service every time the home screen is opened.
  /// Shows the LocationPermissionSheet only if location is not enabled/granted.
  Future<void> checkAndShowLocationSheet() async {
    if (!mounted) return;

    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    final permission = await Geolocator.checkPermission();
    final hasPermission =
        permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always;

    final forcePrompt = sl<PreferencesStorage>().getNeedsLocationPrompt();
    if (forcePrompt) {
      await sl<PreferencesStorage>().saveNeedsLocationPrompt(false);
    }

    if (!hasPermission || !serviceEnabled) {
      if (!_hasPromptedLocationThisSession || forcePrompt) {
        _hasPromptedLocationThisSession = true;
        await _showLocationPermissionSheet();
      } else {
        // Already prompted this session and no forced prompt needed.
        if (mounted) sl<NotificationsCubit>().initNotifications();
      }
    } else {
      // Location is granted — init notifications
      _hasPromptedLocationThisSession =
          true; // No need to prompt later in this session
      if (mounted) sl<NotificationsCubit>().initNotifications();

      // If no saved location exists yet, auto-fetch current position and apply it
      if (selectedLocationId == null && mounted) {
        await _autoFetchAndApplyCurrentLocation();
      }
    }
  }

  Future<void> _autoFetchAndApplyCurrentLocation() async {
    try {
      Position? position;
      try {
        position = await Geolocator.getCurrentPosition(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.high,
            timeLimit: Duration(seconds: 10),
          ),
        );
      } catch (_) {
        position = await Geolocator.getLastKnownPosition();
      }

      if (position == null || !mounted) return;

      // Reverse geocode to get a human-readable address
      String? resolvedAddress;
      try {
        await setLocaleIdentifier('en');
        final placemarks = await placemarkFromCoordinates(
          position.latitude,
          position.longitude,
        );
        if (placemarks.isNotEmpty) {
          final place = placemarks.first;
          final plusCodePattern = RegExp(r'[A-Z0-9]{4,}\+[A-Z0-9]+');
          final parts = [place.street, place.subLocality, place.locality]
              .where(
                (p) =>
                    p != null && p.isNotEmpty && !plusCodePattern.hasMatch(p),
              )
              .cast<String>()
              .toList();
          if (parts.isNotEmpty) resolvedAddress = parts.join(', ');
        }
      } catch (_) {}

      if (!mounted) return;

      await applyLocation(
        latitude: position.latitude,
        longitude: position.longitude,
        resolvedAddress: resolvedAddress,
      );
    } catch (_) {
      // Silent fail — nearby branches will load without location
    }
  }

  Future<void> _showLocationPermissionSheet() async {
    if (!mounted) return;
    await LocationPermissionSheet.show(
      context,
      onLocationApplied: (location) {
        if (mounted) selectSavedLocation(location);
      },
    );
    if (mounted) sl<NotificationsCubit>().initNotifications();
  }
}
