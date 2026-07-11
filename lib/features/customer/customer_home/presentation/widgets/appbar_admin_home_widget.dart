import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:gymbook/core/routes/route_paths.dart';
import 'package:gymbook/core/theme/styles.dart';
import 'package:gymbook/core/widgets/bouncing_social_button.dart';
import 'dart:async';
import 'package:gymbook/core/widgets/custom_search.dart';
import 'package:gymbook/core/widgets/custom_text.dart';
import 'package:gymbook/features/customer/customer_home/presentation/widgets/notification_icon.dart';

class AppbarAdminHomeWidget extends StatefulWidget {
  final String userName;
  final String location;
  final ValueChanged<String>? onSearchChanged;
  final VoidCallback? onAddBranchClosed;

  const AppbarAdminHomeWidget({
    super.key,
    required this.userName,
    required this.location,
    this.onSearchChanged,
    this.onAddBranchClosed,
  });

  @override
  State<AppbarAdminHomeWidget> createState() => _AppbarAdminHomeWidgetState();
}

class _AppbarAdminHomeWidgetState extends State<AppbarAdminHomeWidget> {
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
                        'My Branches',
                        style: font20w700.copyWith(color: Colors.white),
                      ),
                      SizedBox(height: 4.h),
                      AppText(
                        'Manage all your gym locations',
                        style: font14w500.copyWith(
                          // ignore: deprecated_member_use
                          color: Colors.white.withOpacity(0.9),
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
              hintText: "Search branches...",
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
            SizedBox(height: 16.h),
            BouncingSocialButton(
              onTap: () async {
                await GoRouter.of(context).push(Routes.addBranchOneScreen);
                if (widget.onAddBranchClosed != null) {
                  widget.onAddBranchClosed!();
                }
              },
              text: 'Add New Branch',
              icon: Icons.add,
              color: Colors.white,
              textColor: const Color(0xff0EA5E9),
            ),

            SizedBox(height: 24.h),
          ],
        ),
      ),
    );
  }
}
