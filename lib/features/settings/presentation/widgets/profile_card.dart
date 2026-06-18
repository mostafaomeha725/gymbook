import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:gymbook/core/routes/route_paths.dart';
import 'package:gymbook/core/theme/styles.dart';
import 'package:gymbook/core/widgets/bouncing_social_button.dart';
import 'package:gymbook/core/widgets/custom_text.dart';
import 'package:gymbook/features/settings/presentation/cubits/profile_cubit/profile_cubit.dart';
import 'package:gymbook/features/settings/presentation/cubits/profile_cubit/profile_state.dart';

class ProfileCard extends StatelessWidget {
  const ProfileCard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        String fullName = "Loading...";
        String phone = "Loading...";
        String initials = "";

        if (state is ProfileLoaded) {
          final profile = state.profile;
              
          fullName = profile.fullName.isNotEmpty ? profile.fullName : "${profile.firstName} ${profile.lastName}";
          phone = profile.phoneNumber;
          if (profile.firstName.isNotEmpty) {
            initials += profile.firstName[0].toUpperCase();
          }
          if (profile.lastName.isNotEmpty) {
            initials += profile.lastName[0].toUpperCase();
          }
        }

        return Container(
          margin: EdgeInsets.symmetric(horizontal: 12.w),
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 15.r,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                children: [
                  /// Avatar
                  Container(
                    width: 78.w,
                    height: 78.h,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [Color(0xFF0EA5E9), Color(0xFF0284C7)],
                      ),
                    ),
                    alignment: Alignment.center,
                    child: state is ProfileLoading 
                      ? const CircularProgressIndicator(color: Colors.white)
                      : AppText(
                          initials,
                          style: font20w500.copyWith(color: Colors.white),
                          alignment: AlignmentDirectional.center,
                        ),
                  ),

                  SizedBox(width: 16.w),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText(fullName, style: font16w700),
                      SizedBox(height: 4.h),
                      AppText(
                        phone,
                        style: font14w400.copyWith(color: Colors.grey),
                      ),
                    ],
                  ),
                ],
              ),

              SizedBox(height: 16.h),

              BouncingSocialButton(
                text: 'Edit Profile',
                borderColor: Colors.grey,
                icon: Icons.person_outline,
                onTap: () async {
                  await GoRouter.of(context).push(Routes.editProfileScreen);
                  if (context.mounted) {
                    context.read<ProfileCubit>().getProfile();
                  }
                },
                textSize: 14.sp,
                textColor: const Color(0XFF2C3E50),
              ),
            ],
          ),
        );
      },
    );
  }
}
