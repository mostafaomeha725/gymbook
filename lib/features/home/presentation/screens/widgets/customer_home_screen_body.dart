import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:gymbook/core/routes/route_paths.dart';
import 'package:gymbook/core/theme/styles.dart';
import 'package:gymbook/core/widgets/custom_text.dart';
import 'package:gymbook/features/home/presentation/screens/widgets/appbar_home_widget.dart';
import 'package:gymbook/features/home/presentation/screens/widgets/gym_card.dart';
import 'package:gymbook/features/home/presentation/screens/widgets/gym_details_screen_body.dart';
import 'package:gymbook/features/home/presentation/screens/widgets/gym_pagination_widget.dart';
import 'package:gymbook/features/home/presentation/screens/widgets/show_only_open_gym_card.dart';

class CustomerHomeScreenBody extends StatefulWidget {
  const CustomerHomeScreenBody({super.key});

  @override
  State<CustomerHomeScreenBody> createState() => _CustomerHomeScreenBodyState();
}

class _CustomerHomeScreenBodyState extends State<CustomerHomeScreenBody> {
  int _currentSelectedPage = 1;

  void _goToDetails({
    required String gymName,
    required double rating,
    required int reviewsCount,
    required String type,
  }) {
    GoRouter.of(context).push(
      Routes.gymDetailsScreen,
      extra: GymDetailsArgs(
        gymName: gymName,
        rating: rating,
        reviewsCount: reviewsCount,
        type: type,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: SingleChildScrollView(
        child: Column(
          children: [
            const AppbarHomeWidget(userName: 'Ahmed', location: 'Cairo, Egypt'),

            SizedBox(height: 16.h),
            const ShowOnlyOpenGymsCard(),
            SizedBox(height: 24.h),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AppText('Nearby Gyms', style: font20w700),
                  AppText(
                    '6 gyms found',
                    style: font14w400.copyWith(color: const Color(0xff4A5565)),
                  ),
                ],
              ),
            ),

            SizedBox(height: 16.h),

            /// ===== Gyms =====
            GymCard(
              gymName: 'PowerHouse Gym',
              imageUrl: 'https://example.com/gym1.jpg',
              type: 'Mixed',
              rating: 4.8,
              reviewsCount: 234,
              isOpen: true,
              distance: '1.2 km',
              onTap: () => _goToDetails(
                gymName: 'PowerHouse Gym',
                rating: 4.8,
                reviewsCount: 234,
                type: 'Mixed',
              ),
            ),

            GymCard(
              gymName: 'Elite Fitness Center',
              imageUrl: 'https://example.com/gym2.jpg',
              type: 'male',
              rating: 4.6,
              reviewsCount: 189,
              isOpen: true,
              distance: '2.5 km',
              onTap: () => _goToDetails(
                gymName: 'Elite Fitness Center',
                rating: 4.6,
                reviewsCount: 189,
                type: 'male',
              ),
            ),

            GymCard(
              gymName: 'FitZone Studio',
              imageUrl: 'https://example.com/gym3.jpg',
              type: 'female',
              rating: 4.9,
              reviewsCount: 312,
              isOpen: true,
              distance: '3.1 km',
              onTap: () => _goToDetails(
                gymName: 'FitZone Studio',
                rating: 4.9,
                reviewsCount: 312,
                type: 'female',
              ),
            ),

            GymCard(
              gymName: 'Body Balance Gym',
              imageUrl: 'https://example.com/gym4.jpg',
              type: 'Mixed',
              rating: 4.7,
              reviewsCount: 156,
              isOpen: false,
              distance: '4.3 km',
              onTap: () => _goToDetails(
                gymName: 'Body Balance Gym',
                rating: 4.7,
                reviewsCount: 156,
                type: 'Mixed',
              ),
            ),

            GymPaginationWidget(
              totalPages: 3,
              currentPage: _currentSelectedPage,
              onPageChanged: (page) {
                setState(() {
                  _currentSelectedPage = page;
                });
              },
            ),

            SizedBox(height: 132.h),
          ],
        ),
      ),
    );
  }
}
