import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:gymbook/core/routes/route_paths.dart';
import 'package:gymbook/core/theme/styles.dart';
import 'package:gymbook/core/widgets/bouncing_social_button.dart';
import 'package:gymbook/core/widgets/custom_search.dart';
import 'package:gymbook/core/widgets/custom_text.dart';

class AppbarAdminHomeWidget extends StatefulWidget {
  final String userName;
  final String location;
  final ValueChanged<String>? onSearchChanged;

  const AppbarAdminHomeWidget({
    super.key,
    required this.userName,
    required this.location,
    this.onSearchChanged,
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

            CustomSearch(
              controller: searchController,
              hintText: "Search branches...",
              onChanged: widget.onSearchChanged,
            ),
            SizedBox(height: 16.h),
            BouncingSocialButton(
              onTap: () {
                GoRouter.of(context).push(Routes.addBranchOneScreen);
              },
              text: 'Add New Branch',
              icon: Icons.add,
              color: Colors.white,
              textColor: Color(0xff0EA5E9),
            ),

            SizedBox(height: 24.h),
          ],
        ),
      ),
    );
  }
}
