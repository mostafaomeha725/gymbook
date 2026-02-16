import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gymbook/core/theme/styles.dart';
import 'package:gymbook/core/widgets/custom_text.dart';
import 'package:gymbook/features/home/presentation/screens/widgets/amenity_item.dart';

class AmenitiesCard extends StatelessWidget {
  const AmenitiesCard({super.key});

  @override
  Widget build(BuildContext context) {
    List amenities = const [
      AmenityItem(icon: Icons.air, label: 'AC'),
      AmenityItem(icon: Icons.wifi, label: 'WiFi'),
      AmenityItem(icon: Icons.water_drop_outlined, label: 'Showers'),
      AmenityItem(icon: Icons.fitness_center, label: 'Equipment'),
      AmenityItem(icon: Icons.person_outline, label: 'Trainer'),
    ];

    return Container(
      padding: EdgeInsets.all(16.w),
      margin: EdgeInsets.symmetric(horizontal: 24.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.w),
            child: AppText(
              'Amenities',
              style: font18w700.copyWith(color: const Color(0xff1E293B)),
            ),
          ),

          SizedBox(height: 16.h),

          /// Grid
          Wrap(
            spacing: 20.w,
            runSpacing: 20.h,
            children: amenities.map((item) {
              return AmenityWidget(item: item);
            }).toList(),
          ),
        ],
      ),
    );
  }
}
