import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:gymbook/features/customer/customer_home/presentation/models/saved_location.dart';
import 'package:gymbook/features/customer/customer_home/presentation/services/home_location_preferences.dart';
import 'package:gymbook/core/widgets/location_permission_sheet/widgets/location_permission_icon.dart';
import 'package:gymbook/core/widgets/location_permission_sheet/widgets/location_permission_texts.dart';
import 'package:gymbook/core/widgets/location_permission_sheet/widgets/location_permission_features.dart';
import 'package:gymbook/core/widgets/location_permission_sheet/widgets/location_permission_buttons.dart';

class LocationPermissionSheet extends StatefulWidget {
  /// Called after the location is resolved and saved to preferences.
  /// Provides the resolved [SavedLocation] so the caller can immediately
  /// update any in-memory state (e.g. NearbyBranchesCubit).
  final void Function(SavedLocation location)? onLocationApplied;

  const LocationPermissionSheet({super.key, this.onLocationApplied});

  static Future<void> show(
    BuildContext context, {
    void Function(SavedLocation location)? onLocationApplied,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.6),
      isDismissible: false,
      enableDrag: false,
      useSafeArea: true,
      builder: (_) =>
          LocationPermissionSheet(onLocationApplied: onLocationApplied),
    );
  }

  @override
  State<LocationPermissionSheet> createState() =>
      _LocationPermissionSheetState();
}

class _LocationPermissionSheetState extends State<LocationPermissionSheet>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  late AnimationController _controller;
  late Animation<double> _scaleAnim;
  late Animation<double> _fadeAnim;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _scaleAnim = CurvedAnimation(parent: _controller, curve: Curves.elasticOut);
    _fadeAnim = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _controller.forward();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && mounted) {
      _checkIfLocationNowEnabled();
    }
  }

  Future<void> _checkIfLocationNowEnabled() async {
    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) return;

      final permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.whileInUse ||
          permission == LocationPermission.always) {
        if (mounted) {
          setState(() => _isLoading = true);
          await _resolveAndSaveLocation();
        }
      } else if (permission == LocationPermission.denied) {
        // Service was just enabled, now automatically ask for permission
        if (mounted && !_isLoading) {
          _requestLocation();
        }
      }
    } catch (_) {}
  }

  Future<void> _requestLocation() async {
    setState(() => _isLoading = true);

    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        await Geolocator.openLocationSettings();
        if (mounted) setState(() => _isLoading = false);
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.deniedForever) {
        await Geolocator.openAppSettings();
        if (mounted) setState(() => _isLoading = false);
        return;
      }

      if (permission == LocationPermission.whileInUse ||
          permission == LocationPermission.always) {
        await _resolveAndSaveLocation();
        return;
      }
    } catch (_) {}

    if (mounted) setState(() => _isLoading = false);
  }

  Future<void> _resolveAndSaveLocation() async {
    try {
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
        if (mounted) {
          Navigator.of(context).pop();
        }
        return;
      }

      // Reverse geocode
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

      final label = (resolvedAddress != null && resolvedAddress.isNotEmpty)
          ? resolvedAddress
          : 'Lat ${position.latitude.toStringAsFixed(4)}, Lng ${position.longitude.toStringAsFixed(4)}';

      final location = SavedLocation(
        id: SavedLocation.buildId(position.latitude, position.longitude),
        label: label,
        latitude: position.latitude,
        longitude: position.longitude,
      );

      // Save to preferences so HomeScreen picks it up on init
      final prefs = HomeLocationPreferences();
      final existing = await prefs.load();
      final updated = [
        location,
        ...existing.savedLocations.where((l) => l.id != location.id),
      ].take(HomeLocationPreferences.maxSavedLocations).toList();
      await prefs.save(
        savedLocations: updated,
        selectedLocationId: location.id,
      );

      if (mounted) {
        Navigator.of(context).pop();
        widget.onLocationApplied?.call(location);
      }
    } catch (_) {
      if (mounted) {
        Navigator.of(context).pop();
      }
    }
  }

  void _skipLocation() => Navigator.of(context).pop();

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnim,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(28.r),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Drag handle
            SizedBox(height: 12.h),
            Container(
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: const Color(0xffE2E8F0),
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
            SizedBox(height: 32.h),

            LocationPermissionIcon(scaleAnim: _scaleAnim),
            SizedBox(height: 24.h),

            const LocationPermissionTexts(),
            SizedBox(height: 28.h),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: const LocationPermissionFeatures(),
            ),
            SizedBox(height: 28.h),

            LocationPermissionButtons(
              isLoading: _isLoading,
              onRequestLocation: _requestLocation,
              onSkipLocation: _skipLocation,
            ),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }
}
