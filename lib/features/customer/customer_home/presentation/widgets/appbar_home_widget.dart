import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gymbook/core/theme/styles.dart';
import 'dart:async';
import 'package:gymbook/core/widgets/custom_search.dart';
import 'package:gymbook/core/widgets/custom_text.dart';

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
  Timer? _debounce;

  @override
  void dispose() {
    _debounce?.cancel();
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
                        borderRadius: BorderRadius.circular(12.r),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 12.w,
                            vertical: 8.h,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12.r),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.3),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.location_on,
                                color: Colors.white,
                                size: 20.sp,
                              ),
                              SizedBox(width: 6.w),
                              Flexible(
                                child: AppText(
                                  widget.location,
                                  maxLines: 1,
                                  style: font14w700.copyWith(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              SizedBox(width: 6.w),
                              Icon(
                                Icons.keyboard_arrow_down_rounded,
                                color: Colors.white,
                                size: 20.sp,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            SizedBox(height: 20.h),

            CustomSearch(
              controller: searchController,
              hintText: "Find gyms near you...",
              onChanged: (value) {
                final trimValue = value.trim();
                if (trimValue.isNotEmpty && trimValue.length < 3) return;

                if (_debounce?.isActive ?? false) _debounce!.cancel();
                _debounce = Timer(const Duration(milliseconds: 400), () {
                  if (widget.onSearchChanged != null) {
                    widget.onSearchChanged!(value);
                  }
                });
              },
              onSubmitted: (value) {
                if (_debounce?.isActive ?? false) _debounce!.cancel();
                if (widget.onSearchChanged != null) {
                  widget.onSearchChanged!(value);
                }
              },
            ),

            SizedBox(height: 24.h),
          ],
        ),
      ),
    );
  }
}
