import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gymbook/core/theme/styles.dart';
import 'package:gymbook/core/widgets/custom_text.dart';
import 'package:gymbook/core/widgets/app_form_field.dart';
import 'package:gymbook/features/auth/presentation/screens/widgets/bouncing_social_button.dart';

class AppbarAdminHomeWidget extends StatefulWidget {
  final String userName;
  final String location;

  const AppbarAdminHomeWidget({
    super.key,
    required this.userName,
    required this.location,
  });

  @override
  State<AppbarAdminHomeWidget> createState() => _AppbarAdminHomeWidgetState();
}

class _AppbarAdminHomeWidgetState extends State<AppbarAdminHomeWidget> {
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
              ],
            ),

            SizedBox(height: 24.h),

            AppFormField(
              controller: searchController,
              hintText: 'Search branches...',
              fillColor: Colors.white,
              radius: 16.r,
              borderColor: Colors.transparent,
              prefixIcon: Padding(
                padding: EdgeInsets.only(left: 8.w),
                child: Icon(
                  Icons.search,
                  color: const Color(0xFF94A3B8),
                  size: 24.sp,
                ),
              ),
              maxLines: 1,
              contentPadding: EdgeInsets.symmetric(
                vertical: 15.h,
                horizontal: 10.w,
              ),
            ),
            SizedBox(height: 16.h),
            BouncingSocialButton(
              text: 'Add New Branch',
              icon: Icons.add,
              color: Colors.white,
            ),

            SizedBox(height: 24.h),
          ],
        ),
      ),
    );
  }
}
