import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gymbook/core/theme/styles.dart';
import 'package:gymbook/core/widgets/custom_text.dart';
import 'package:gymbook/features/customer/customer_home/presentation/widgets/amenity_item.dart';

class AmenitiesCard extends StatelessWidget {
  const AmenitiesCard({super.key});

  @override
  Widget build(BuildContext context) {
    final amenities = [
      const AmenityItem(icon: Icons.air, label: 'AC'),
      const AmenityItem(icon: Icons.wifi, label: 'WiFi'),
      const AmenityItem(icon: Icons.water_drop_outlined, label: 'Showers'),
      const AmenityItem(icon: Icons.fitness_center, label: 'Equipment'),
      const AmenityItem(icon: Icons.person_outline, label: 'Trainer'),
      const AmenityItem(icon: Icons.chair_outlined, label: 'Lounge'),
    ];

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 24.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: Colors.black.withOpacity(0.06)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(
            'Amenities',
            style: font16w500.copyWith(color: const Color(0xff0F172A)),
            textPadding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
          ),

          GridView.count(
            padding: EdgeInsets.zero,
            crossAxisCount: 3,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 0,
            children: amenities
                .map((item) => AmenityWidget(item: item))
                .toList(),
          ),
        ],
      ),
    );
  }
}
