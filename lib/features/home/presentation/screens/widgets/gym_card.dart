import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gymbook/core/theme/styles.dart';
import 'package:gymbook/core/widgets/custom_text.dart';
import 'package:gymbook/features/admin_home/presentation/screens/widgets/get_type_color.dart';

class GymCard extends StatelessWidget {
  final String gymName;
  final String imageUrl;
  final String type;
  final double rating;
  final int reviewsCount;
  final bool isOpen;
  final String distance;
  final void Function()? onTap;

  const GymCard({
    super.key,
    required this.gymName,
    required this.imageUrl,
    required this.type,
    required this.rating,
    required this.reviewsCount,
    required this.isOpen,
    required this.distance,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 16.h, left: 16.w, right: 16.w),
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          children: [
            // صورة الجيم
            ClipRRect(
              borderRadius: BorderRadius.circular(16.r),
              child: Image.network(
                imageUrl,
                width: 90.w,
                height: 90.w,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  width: 90.w,
                  height: 90.w,
                  color: Colors.grey[200],
                  child: const Icon(Icons.image_not_supported),
                ),
              ),
            ),
            SizedBox(width: 16.w),
            // تفاصيل الجيم
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(
                    gymName,
                    style: font18w500.copyWith(
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF1E293B),
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildBadge(
                        text: type,
                        bgColor: GetTypeColor()
                            .getTypeColor(type)
                            .withOpacity(0.1),
                        textColor: GetTypeColor().getTypeColor(type),
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.star_rounded,
                            color: Colors.amber,
                            size: 20.sp,
                          ),
                          AppText(
                            '$rating ($reviewsCount)',
                            style: font14w500.copyWith(
                              color: const Color(0xFF64748B),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildBadge(
                        text: isOpen ? 'Open Now' : 'Closed',
                        bgColor: isOpen
                            ? const Color(0xFFDCFCE7)
                            : const Color(0xFFFEE2E2),
                        textColor: isOpen
                            ? const Color(0xFF166534)
                            : const Color(0xFF991B1B),
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.near_me_outlined,
                            size: 16.sp,
                            color: const Color(0xFF64748B),
                          ),
                          SizedBox(width: 4.w),
                          AppText(
                            distance,
                            style: font14w500.copyWith(
                              color: const Color(0xFF64748B),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBadge({
    required String text,
    required Color bgColor,
    required Color textColor,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: AppText(
        text,
        style: font12w500.copyWith(
          color: textColor,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
