import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:gymbook/features/auth/presentation/widgets/location_on_map_card.dart';
import 'package:gymbook/features/customer/customer_home/presentation/models/saved_location.dart';
import 'package:gymbook/features/customer/customer_home/presentation/widgets/location_picker_bottom_sheet.dart';
import 'package:latlong2/latlong.dart';

class CustomerHomeLocationActions {
  Future<void> openLocationPicker({
    required BuildContext context,
    required List<SavedLocation> savedLocations,
    required String? selectedLocationId,
    required ValueChanged<SavedLocation> onSelectSaved,
    required VoidCallback onUseCurrentLocation,
    required VoidCallback onChooseFromMap,
  }) async {
    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (sheetContext) {
        return LocationPickerBottomSheet(
          savedLocations: savedLocations,
          selectedLocationId: selectedLocationId,
          onSelectSaved: (location) {
            Navigator.of(sheetContext).pop();
            onSelectSaved(location);
          },
          onUseCurrentLocation: () {
            Navigator.of(sheetContext).pop();
            onUseCurrentLocation();
          },
          onChooseFromMap: () {
            Navigator.of(sheetContext).pop();
            onChooseFromMap();
          },
        );
      },
    );
  }

  Future<void> useCurrentLocation({
    required BuildContext context,
    required Future<void> Function({
      required double latitude,
      required double longitude,
      String? resolvedAddress,
    })
    onLocationResolved,
  }) async {
    EasyLoading.show(status: 'Getting current location...');
    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Location service is disabled')),
        );
        return;
      }

      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Location permission is required')),
        );
        return;
      }

      Position? position;
      try {
        position = await Geolocator.getCurrentPosition(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.high,
            timeLimit: Duration(seconds: 12),
          ),
        );
      } catch (_) {
        position = await Geolocator.getLastKnownPosition();
      }

      if (position == null) {
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Unable to get current location')),
        );
        return;
      }

      final resolvedAddress = await _resolveAddressFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (!context.mounted) return;
      await onLocationResolved(
        latitude: position.latitude,
        longitude: position.longitude,
        resolvedAddress: resolvedAddress,
      );
    } finally {
      EasyLoading.dismiss();
    }
  }

  Future<void> useMapLocation({
    required BuildContext context,
    required Future<void> Function({
      required double latitude,
      required double longitude,
      String? resolvedAddress,
    })
    onLocationResolved,
  }) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const MapPickerScreen()),
    );

    if (result is! LatLng) return;

    EasyLoading.show(status: 'Applying selected location...');
    try {
      final resolvedAddress = await _resolveAddressFromCoordinates(
        result.latitude,
        result.longitude,
      );

      if (!context.mounted) return;
      await onLocationResolved(
        latitude: result.latitude,
        longitude: result.longitude,
        resolvedAddress: resolvedAddress,
      );
    } finally {
      EasyLoading.dismiss();
    }
  }

  Future<String?> _resolveAddressFromCoordinates(
    double latitude,
    double longitude,
  ) async {
    try {
      await setLocaleIdentifier('en');
      final placemarks = await placemarkFromCoordinates(latitude, longitude);
      if (placemarks.isEmpty) return null;

      final place = placemarks.first;
      final plusCodePattern = RegExp(r'[A-Z0-9]{4,}\+[A-Z0-9]+');
      final parts =
          [
                place.street,
                place.subLocality,
                place.locality,
                place.administrativeArea,
              ]
              .where((part) {
                return part != null &&
                    part.isNotEmpty &&
                    !plusCodePattern.hasMatch(part);
              })
              .cast<String>()
              .toList();

      if (parts.isEmpty) return null;
      return parts.join(', ');
    } catch (_) {
      return null;
    }
  }
}
