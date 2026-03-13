import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gymbook/core/theme/styles.dart';
import 'package:gymbook/core/widgets/custom_search.dart';
import 'package:gymbook/core/widgets/custom_text.dart';
import 'package:gymbook/features/home/presentation/widgets/notification_icon.dart';

class AppbarHomeWidget extends StatefulWidget {
  final String userName;
  final String location;

  const AppbarHomeWidget({
    super.key,
    required this.userName,
    required this.location,
  });

  @override
  State<AppbarHomeWidget> createState() => _AppbarHomeWidgetState();
}

class _AppbarHomeWidgetState extends State<AppbarHomeWidget> {
  final TextEditingController searchController = TextEditingController();

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,

      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF0EA5E9), Color(0xFF0284C7)],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(28.r),
          bottomRight: Radius.circular(28.r),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 40.h),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(
                      'Hi, ${widget.userName}',
                      style: font20w700.copyWith(color: Colors.white),
                    ),
                    SizedBox(height: 4.h),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          color: Colors.white,
                          size: 16.sp,
                        ),
                        SizedBox(width: 4.w),
                        AppText(
                          widget.location,
                          style: font14w500.copyWith(
                            // ignore: deprecated_member_use
                            color: Colors.white.withOpacity(0.9),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const NotificationIcon(),
              ],
            ),

            SizedBox(height: 24.h),

            CustomSearch(
              controller: searchController,
              hintText: "Find gyms near you...",
            ),

            SizedBox(height: 24.h),
          ],
        ),
      ),
    );
  }
}
