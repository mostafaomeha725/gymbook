import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:gymbook/core/routes/route_paths.dart';
import 'package:gymbook/features/auth/presentation/screens/register_screen.dart';
import 'package:gymbook/core/theme/styles.dart';
import 'package:gymbook/core/widgets/custom_text.dart';
import 'package:gymbook/features/auth/presentation/widgets/gymbook_card.dart';
import 'package:gymbook/features/auth/presentation/widgets/join_as_member_card.dart';

class JoinUsScreenBody extends StatelessWidget {
  const JoinUsScreenBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          GymbookCard(
            title: 'Join GymBook',
            subtitle: 'Start your fitness journey today',
            height: 180.h,
            height1: 50.h,
          ),
          SizedBox(height: 28.h),
          JoinAsMemberCard(
            color: const Color(0xff0284C7),
            text: const [
              'Browse hundreds of gyms',
              'Flexible membership plans',
              'QR code entry access',
            ],
            text1: 'Join as Member',
            text2: 'Find and book gyms near you',
            textbutton: 'Join as Member',
            icon: Icons.person_outline,
            onpressed: () {
              GoRouter.of(
                context,
              ).push(Routes.registerScreen, extra: RegisterType.customer);
            },
          ),
          SizedBox(height: 22.h),
          JoinAsMemberCard(
            color: const Color(0xff2C3E50),
            text: const [
              'Manage members & subscriptions',
              'Real-time analytics dashboard',
              'QR code check-in system',
            ],
            text1: "I'm a Gym Owner",
            text2: 'Grow your gym business',
            textbutton: 'Register Your Gym',
            onpressed: () {
              GoRouter.of(
                context,
              ).push(Routes.registerScreen, extra: RegisterType.business);
            },
            icon: Icons.fitness_center_outlined,
          ),
          SizedBox(height: 16.h),
          Padding(
            padding: EdgeInsets.only(bottom: 46.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AppText(
                  "Already have an account? ",
                  style: font16w400.copyWith(color: const Color(0xff364153)),
                ),
                GestureDetector(
                  onTap: () {
                    GoRouter.of(context).push(Routes.loginScreen);
                  },
                  child: AppText(
                    "Sign In",
                    style: font16w600.copyWith(color: const Color(0xff0EA5E9)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
