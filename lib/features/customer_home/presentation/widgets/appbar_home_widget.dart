import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gymbook/core/theme/styles.dart';
import 'package:gymbook/core/widgets/custom_search.dart';
import 'package:gymbook/core/widgets/custom_text.dart';
import 'package:gymbook/features/customer_home/presentation/widgets/notification_icon.dart';

class AppbarHomeWidget extends StatefulWidget {
  final String userName;
  final String location;
  final ValueChanged<String>? onSearchChanged;
  final VoidCallback? onLocationTap;

  const AppbarHomeWidget({
    super.key,
    required this.userName,
    required this.location,
    this.onSearchChanged,
    this.onLocationTap,
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
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText(
                        'Hi, ${widget.userName}',
                        style: font20w700.copyWith(color: Colors.white),
                      ),
                      SizedBox(height: 4.h),
                      InkWell(
                        onTap: widget.onLocationTap,
                        borderRadius: BorderRadius.circular(8.r),
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 2.h),
                          child: Row(
                            children: [
                              Icon(
                                Icons.location_on_outlined,
                                color: Colors.white,
                                size: 16.sp,
                              ),
                              SizedBox(width: 4.w),
                              Flexible(
                                child: AppText(
                                  widget.location,
                                  maxLines: 3,
                                  style: font14w500.copyWith(
                                    // ignore: deprecated_member_use
                                    color: Colors.white.withOpacity(0.9),
                                  ),
                                ),
                              ),
                              SizedBox(width: 4.w),
                              Icon(
                                Icons.keyboard_arrow_down_rounded,
                                color: Colors.white,
                                size: 16.sp,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const NotificationIcon(),
              ],
            ),

            SizedBox(height: 24.h),

            CustomSearch(
              controller: searchController,
              hintText: "Find gyms near you...",
              onChanged: widget.onSearchChanged,
            ),

            SizedBox(height: 24.h),
          ],
        ),
      ),
    );
  }
}
