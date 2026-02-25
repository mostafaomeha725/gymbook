import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:gymbook/core/theme/styles.dart';
import 'package:gymbook/core/widgets/custom_text.dart';
import 'package:latlong2/latlong.dart';

import 'package:geocoding/geocoding.dart'; // استيراد المكتبة الجديدة

class LocationOnMapCard extends StatefulWidget {
  final Color? borderColor;
  final void Function(String address)? onAddressSelected;

  const LocationOnMapCard({
    super.key,
    this.borderColor,
    this.onAddressSelected,
  });

  @override
  State<LocationOnMapCard> createState() => _LocationOnMapCardState();
}

class _LocationOnMapCardState extends State<LocationOnMapCard> {
  LatLng? _selectedLocation;
  String? _address; // متغير جديد لحفظ العنوان
  bool _isFetchingAddress = false;

  Future<void> _openMapPicker() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const MapPickerScreen()),
    );

    if (result != null && result is LatLng) {
      setState(() {
        _selectedLocation = result;
        _isFetchingAddress = true; // بدأنا نجيب العنوان
      });

      // تحويل الإحداثيات لعنوان
      await _getAddressFromLatLng(result);
    }
  }

  Future<void> _getAddressFromLatLng(LatLng position) async {
    try {
      await setLocaleIdentifier("en");

      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];

        // Plus codes look like "XWFC+97X" — filter any part containing them
        final plusCodePattern = RegExp(r'[A-Z0-9]{4,}\+[A-Z0-9]+');

        final parts =
            [
                  place.street,
                  place.subLocality,
                  place.locality,
                  place.administrativeArea,
                ]
                .where(
                  (p) =>
                      p != null && p.isNotEmpty && !plusCodePattern.hasMatch(p),
                )
                .cast<String>()
                .toList();

        final address = parts.join(', ');
        setState(() {
          _address = address;
          _isFetchingAddress = false;
        });
        widget.onAddressSelected?.call(address);
      }
    } catch (e) {
      debugPrint(e.toString());
      setState(() {
        _address = "Address not found";
        _isFetchingAddress = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(
          'Location on Map',
          style: font14w500.copyWith(color: Colors.black54),
        ),
        SizedBox(height: 8.h),
        GestureDetector(
          onTap: _openMapPicker,
          child: Container(
            height: 200.h,
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xffF3F4F6),
              borderRadius: BorderRadius.circular(20.r),
              border: Border.all(
                color: widget.borderColor ?? const Color(0xffE5E7EB),
              ),
            ),
            padding: EdgeInsets.all(16.w),
            child: _selectedLocation == null
                ? _buildPlaceholder()
                : _buildSelectedLocationInfo(),
          ),
        ),
      ],
    );
  }

  // الجزء الخاص بالPlaceholder (لو مفيش اختيار)
  Widget _buildPlaceholder() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.location_on_outlined,
          size: 48.sp,
          color: widget.borderColor ?? const Color(0xffE5E7EB),
        ),
        SizedBox(height: 8.h),
        AppText(
          'Select location on map',
          style: font14w400.copyWith(
            color: widget.borderColor ?? const Color(0xffE5E7EB),
          ),
          alignment: AlignmentDirectional.center,
        ),
      ],
    );
  }

  // الجزء الخاص بعرض العنوان بعد الاختيار
  Widget _buildSelectedLocationInfo() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.location_on, size: 40.sp, color: Colors.green),
        SizedBox(height: 8.h),
        AppText(
          'Location Selected',
          style: font14w700.copyWith(color: Colors.green),
          alignment: AlignmentDirectional.center,
        ),
        SizedBox(height: 6.h),

        if (_isFetchingAddress)
          const CircularProgressIndicator(strokeWidth: 2)
        else
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            child: AppText(
              _address ?? "Unknown Address",
              style: font12w400.copyWith(color: const Color(0xff364153)),
              alignment: AlignmentDirectional.center,
              // عشان لو العنوان طويل ميبوظش التصميم
              maxLines: 2,
            ),
          ),
      ],
    );
  }
}

class MapPickerScreen extends StatefulWidget {
  const MapPickerScreen({super.key});

  @override
  State<MapPickerScreen> createState() => _MapPickerScreenState();
}

class _MapPickerScreenState extends State<MapPickerScreen> {
  LatLng? selectedLocation;
  bool _loading = true;
  final MapController _mapController = MapController();

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  // الحصول على الموقع الحالي عند فتح الخريطة
  Future<void> _getCurrentLocation() async {
    try {
      setState(() => _loading = true);

      /// 1️⃣ تأكد إن خدمة الموقع شغالة
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        await Geolocator.openLocationSettings();
        setState(() => _loading = false);
        return;
      }

      /// 2️⃣ تحقق من الإذن
      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() => _loading = false);
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        await Geolocator.openAppSettings();
        setState(() => _loading = false);
        return;
      }

      /// 3️⃣ جيب الموقع
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 10),
      );

      final latLng = LatLng(position.latitude, position.longitude);

      setState(() {
        selectedLocation = latLng;
        _loading = false;
      });

      _mapController.move(latLng, 15);
    } catch (e) {
      debugPrint("Location error: $e");

      /// 🔥 مهم جدًا عشان مايفضلش لودينج
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Location'),
        backgroundColor: const Color(0xFF0EA5E9),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                FlutterMap(
                  mapController: _mapController,
                  options: MapOptions(
                    initialCenter:
                        selectedLocation ?? const LatLng(30.0444, 31.2357),
                    initialZoom: 15,
                    onTap: (tapPosition, latLng) {
                      setState(() {
                        selectedLocation = latLng;
                      });
                      // تحريك الكاميرا للمكان المختار بنعومة
                      _mapController.move(latLng, 15);
                    },
                  ),
                  children: [
                    TileLayer(
                      urlTemplate:
                          'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'com.example.gymbook',
                    ),
                    if (selectedLocation != null)
                      MarkerLayer(
                        markers: [
                          Marker(
                            point: selectedLocation!,
                            width: 50.w,
                            height: 50.h,
                            alignment: Alignment
                                .topCenter, // لجعل سن الدبوس على الموقع بالضبط
                            child: Icon(
                              Icons.location_on,
                              color: Colors.red,
                              size: 45.sp,
                            ),
                          ),
                        ],
                      ),
                  ],
                ),

                // زر العودة للموقع الحالي
                Positioned(
                  bottom: 100.h,
                  right: 20.w,
                  child: FloatingActionButton(
                    backgroundColor: Colors.white,
                    onPressed: _getCurrentLocation,
                    child: const Icon(
                      Icons.my_location,
                      color: Color(0xFF0EA5E9),
                    ),
                  ),
                ),

                // زر التأكيد في أسفل الشاشة
                if (selectedLocation != null)
                  Positioned(
                    bottom: 30.h,
                    left: 20.w,
                    right: 20.w,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0EA5E9),
                        padding: EdgeInsets.symmetric(vertical: 15.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                      onPressed: () => Navigator.pop(context, selectedLocation),
                      child: Text(
                        'Confirm Location',
                        style: font16w700.copyWith(color: Colors.white),
                      ),
                    ),
                  ),
              ],
            ),
    );
  }
}
