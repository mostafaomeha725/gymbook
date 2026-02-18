import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gymbook/core/theme/styles.dart';
import 'package:gymbook/core/widgets/custom_text.dart';
import 'package:gymbook/core/widgets/app_image.dart';
import 'package:gymbook/core/widgets/switch_open_gym.dart';
import 'package:gymbook/features/admin_home/presentation/widgets/tag_bage.dart';

class BranchHeaderSection extends StatefulWidget {
  const BranchHeaderSection({super.key});

  @override
  State<BranchHeaderSection> createState() => _BranchHeaderSectionState();
}

class _BranchHeaderSectionState extends State<BranchHeaderSection> {
  bool isOpen = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            AppImage(
              imageUrl:
                  'https://images.unsplash.com/photo-1506744038136-46273834b3fb',
              height: 200.h,
              width: double.infinity,
              fit: BoxFit.cover,
            ),

            Positioned(
              top: 16.h,
              left: 16.w,
              child: const CircleAvatar(
                backgroundColor: Colors.black45,
                child: Icon(Icons.arrow_back, color: Colors.white),
              ),
            ),

            Positioned(
              bottom: -40.h,
              left: 24.w,
              child: CircleAvatar(
                radius: 43.r,
                backgroundColor: Colors.white,
                child: CircleAvatar(
                  radius: 40.r,
                  backgroundImage: const NetworkImage(
                    'https://randomuser.me/api/portraits/men/32.jpg',
                  ),
                ),
              ),
            ),
          ],
        ),

        SizedBox(height: 44.h),

        Padding(
          padding: EdgeInsets.symmetric(horizontal: 22.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppText(
                'Maadi Branch',
                style: font20w700.copyWith(color: const Color(0xff2C3E50)),
              ),

              Transform.scale(
                scale: 0.8.h,
                child: OpenGymSwitch(
                  value: isOpen,
                  onChanged: (value) {
                    setState(() {
                      isOpen = value;
                    });
                  },
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 22.w),
          child: Row(
            children: [
              const TagBadge(tag: 'male'),
              SizedBox(width: 12.w),
              const TagBadge(tag: 'Active'),
            ],
          ),
        ),
      ],
    );
  }
}
