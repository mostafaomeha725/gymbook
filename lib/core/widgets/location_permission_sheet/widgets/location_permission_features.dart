import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LocationPermissionFeatures extends StatelessWidget {
  const LocationPermissionFeatures({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const _FeatureRow(
          icon: Icons.search_rounded,
          iconColor: Color(0xFF8B5CF6),
          title: 'Find Nearby Gyms',
          subtitle: 'Discover gyms around your location',
        ),
        SizedBox(height: 12.h),
        const _FeatureRow(
          icon: Icons.directions_rounded,
          iconColor: Color(0xFF10B981),
          title: 'Get Directions',
          subtitle: 'Navigate to your gym easily',
        ),
        SizedBox(height: 12.h),
        const _FeatureRow(
          icon: Icons.star_rounded,
          iconColor: Color(0xFFF59E0B),
          title: 'Personalized Results',
          subtitle: 'Get recommendations based on distance',
        ),
      ],
    );
  }
}

class _FeatureRow extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;

  const _FeatureRow({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 40.w,
          height: 40.w,
          decoration: BoxDecoration(
            color: iconColor.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Icon(icon, color: iconColor, size: 20.sp),
        ),
        SizedBox(width: 14.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xff0F172A),
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 11.sp,
                  color: const Color(0xff94A3B8),
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
