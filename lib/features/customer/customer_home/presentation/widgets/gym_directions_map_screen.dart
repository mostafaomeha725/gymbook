import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:gymbook/core/theme/styles.dart';
import 'package:latlong2/latlong.dart';

class GymDirectionsMapScreen extends StatefulWidget {
  final String gymName;
  final String gymAddress;
  final double gymLatitude;
  final double gymLongitude;

  const GymDirectionsMapScreen({
    super.key,
    required this.gymName,
    required this.gymAddress,
    required this.gymLatitude,
    required this.gymLongitude,
  });

  @override
  State<GymDirectionsMapScreen> createState() => _GymDirectionsMapScreenState();
}

class _GymDirectionsMapScreenState extends State<GymDirectionsMapScreen> {
  final MapController _mapController = MapController();

  LatLng? _userLocation;
  bool _loading = true;
  bool _showRoute = false;
  StreamSubscription<Position>? _positionSubscription;

  LatLng get _gymLocation => LatLng(widget.gymLatitude, widget.gymLongitude);

  @override
  void initState() {
    super.initState();
    _startTracking();
  }

  @override
  void dispose() {
    _positionSubscription?.cancel();
    super.dispose();
  }

  Future<void> _startTracking() async {
    try {
      setState(() => _loading = true);

      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Location service is disabled')),
        );
        setState(() => _loading = false);
        return;
      }

      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Location permission is required')),
        );
        setState(() => _loading = false);
        return;
      }

      Position? currentPosition;
      try {
        currentPosition = await Geolocator.getCurrentPosition(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.high,
            timeLimit: Duration(seconds: 12),
          ),
        );
      } catch (_) {
        currentPosition = await Geolocator.getLastKnownPosition();
      }

      if (!mounted) return;
      if (currentPosition != null) {
        _setUserLocation(
          LatLng(currentPosition.latitude, currentPosition.longitude),
          moveCamera: true,
        );
      }

      _positionSubscription =
          Geolocator.getPositionStream(
            locationSettings: const LocationSettings(
              accuracy: LocationAccuracy.high,
              distanceFilter: 10,
            ),
          ).listen((position) {
            if (!mounted) return;
            _setUserLocation(
              LatLng(position.latitude, position.longitude),
              moveCamera: false,
            );
          });
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  void _setUserLocation(LatLng location, {required bool moveCamera}) {
    setState(() {
      _userLocation = location;
    });

    if (moveCamera) {
      _mapController.move(location, 14);
    }
  }

  List<LatLng> _routePoints() {
    if (_userLocation == null) return const [];
    return [_userLocation!, _gymLocation];
  }

  void _toggleRoute() {
    if (_userLocation == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Current location is not available yet')),
      );
      return;
    }

    setState(() {
      _showRoute = !_showRoute;
    });

    if (_showRoute) {
      final bounds = LatLngBounds.fromPoints([_userLocation!, _gymLocation]);
      _mapController.fitCamera(
        CameraFit.bounds(bounds: bounds, padding: EdgeInsets.all(50.w)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final routePoints = _routePoints();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.gymName),
        backgroundColor: const Color(0xFF0EA5E9),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                FlutterMap(
                  mapController: _mapController,
                  options: MapOptions(
                    initialCenter: _userLocation ?? _gymLocation,
                    initialZoom: 14,
                  ),
                  children: [
                    TileLayer(
                      urlTemplate:
                          'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'com.example.gymbook',
                    ),
                    if (_showRoute && routePoints.length == 2)
                      PolylineLayer(
                        polylines: [
                          Polyline(
                            points: routePoints,
                            strokeWidth: 5,
                            color: const Color(0xFF0EA5E9),
                          ),
                        ],
                      ),
                    MarkerLayer(
                      markers: [
                        Marker(
                          point: _gymLocation,
                          width: 54.w,
                          height: 54.h,
                          alignment: Alignment.topCenter,
                          child: Icon(
                            Icons.location_on,
                            color: Colors.red,
                            size: 46.sp,
                          ),
                        ),
                        if (_userLocation != null)
                          Marker(
                            point: _userLocation!,
                            width: 24.w,
                            height: 24.h,
                            child: Container(
                              decoration: BoxDecoration(
                                color: const Color(0xFF0EA5E9),
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white,
                                  width: 3,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
                Positioned(
                  left: 16.w,
                  right: 16.w,
                  bottom: 20.h,
                  child: Container(
                    padding: EdgeInsets.all(12.w),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Destination',
                          style: font12w500.copyWith(
                            color: const Color(0xff64748B),
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          widget.gymAddress,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: font14w700,
                        ),
                        SizedBox(height: 10.h),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF0EA5E9),
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(vertical: 12.h),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.r),
                              ),
                            ),
                            onPressed: _toggleRoute,
                            icon: Icon(
                              _showRoute
                                  ? Icons.visibility_off_outlined
                                  : Icons.alt_route,
                              size: 18.sp,
                            ),
                            label: Text(
                              _showRoute ? 'Hide Route' : 'Show Route',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  right: 16.w,
                  bottom: 100.h,
                  child: FloatingActionButton(
                    backgroundColor: Colors.white,
                    onPressed: () {
                      if (_userLocation != null) {
                        _mapController.move(_userLocation!, 15);
                      }
                    },
                    child: const Icon(
                      Icons.my_location,
                      color: Color(0xFF0EA5E9),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
