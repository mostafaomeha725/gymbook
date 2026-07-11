import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gymbook/core/theme/styles.dart';
import 'package:gymbook/core/widgets/custom_text.dart';

class LocationPickerActions extends StatelessWidget {
  final VoidCallback onUseCurrentLocation;
  final VoidCallback onChooseFromMap;

  const LocationPickerActions({
    super.key,
    required this.onUseCurrentLocation,
    required this.onChooseFromMap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 8.w),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
          leading: Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Icon(
              Icons.my_location_rounded,
              color: Colors.blue.shade700,
              size: 20.sp,
            ),
          ),
          title: AppText(
            'Use current location',
            style: font14w500.copyWith(color: const Color(0xff334155)),
          ),
          onTap: onUseCurrentLocation,
        ),
        ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 8.w),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
          leading: Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: Colors.orange.shade50,
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Icon(
              Icons.map_rounded,
              color: Colors.orange.shade700,
              size: 20.sp,
            ),
          ),
          title: AppText(
            'Choose from map',
            style: font14w500.copyWith(color: const Color(0xff334155)),
          ),
          onTap: onChooseFromMap,
        ),
      ],
    );
  }
}
