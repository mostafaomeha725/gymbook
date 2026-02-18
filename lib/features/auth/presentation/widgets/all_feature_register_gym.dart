import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:gymbook/core/constants/app_assets.dart';
import 'package:gymbook/core/routes/route_paths.dart';
import 'package:gymbook/core/theme/styles.dart';
import 'package:gymbook/core/widgets/app_form_field.dart';
import 'package:gymbook/core/widgets/bouncing_social_button.dart';
import 'package:gymbook/core/widgets/custom_button.dart';
import 'package:gymbook/core/widgets/custom_text.dart';
import 'package:gymbook/features/auth/presentation/widgets/gym_type_selector.dart';
import 'package:gymbook/features/auth/presentation/widgets/location_on_map_card.dart';
import 'package:image_picker/image_picker.dart';

class AllFeatureRegisterGym extends StatefulWidget {
  const AllFeatureRegisterGym({super.key});

  @override
  State<AllFeatureRegisterGym> createState() => _AllFeatureRegisterGymState();
}

class _AllFeatureRegisterGymState extends State<AllFeatureRegisterGym> {
  final TextEditingController gymNamecontroller = TextEditingController();
  final TextEditingController addresscontroller = TextEditingController();

  final ImagePicker _picker = ImagePicker();

  File? _logoImage;
  List<File> _gymImages = [];

  @override
  void dispose() {
    gymNamecontroller.dispose();
    addresscontroller.dispose();
    super.dispose();
  }

  /// ================= Pick Gym Logo =================
  Future<void> _pickLogo() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (image != null) {
      setState(() {
        _logoImage = File(image.path);
      });
    }
  }

  /// ================= Pick Gym Photos (max 6) =================
  Future<void> _pickGymImages() async {
    final List<XFile>? images = await _picker.pickMultiImage(imageQuality: 80);

    if (images == null || images.isEmpty) return;

    final remaining = 6 - _gymImages.length;

    if (remaining <= 0) {
      _showLimitMessage();
      return;
    }

    if (images.length > remaining) {
      _showLimitMessage();
    }

    setState(() {
      _gymImages.addAll(images.take(remaining).map((e) => File(e.path)));
    });
  }

  void _showLimitMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Maximum 6 photos allowed'),
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// ================= Gym Name =================
          SizedBox(height: 32.h),
          AppText(
            'Gym Name',
            style: font14w500.copyWith(color: const Color(0xff364153)),
          ),
          SizedBox(height: 8.h),
          AppFormField(
            controller: gymNamecontroller,
            hintText: 'Enter gym name',
            maxLines: 1,
            prefixIcon: Padding(
              padding: EdgeInsets.only(left: 8.w),
              child: Icon(Icons.fitness_center, size: 22.sp),
            ),
            radius: 22.r,
          ),

          SizedBox(height: 16.h),

          /// ================= Gym Logo =================
          AppText(
            'Gym Logo',
            style: font14w500.copyWith(color: const Color(0xff364153)),
          ),
          SizedBox(height: 8.h),

          Row(
            children: [
              GestureDetector(
                onTap: _pickLogo,
                child: Container(
                  height: 80.h,
                  width: 80.w,
                  decoration: BoxDecoration(
                    color: const Color(0xffF9FAFB),
                    borderRadius: BorderRadius.circular(16.r),
                    border: Border.all(color: const Color(0xffE5E7EB)),
                    image: _logoImage != null
                        ? DecorationImage(
                            image: FileImage(_logoImage!),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  child: _logoImage == null
                      ? Icon(
                          Icons.upload_outlined,
                          size: 28.sp,
                          color: const Color(0xff9CA3AF),
                        )
                      : null,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: BouncingSocialButton(
                  text: "Upload Logo",
                  assetName: Assets.upload,
                  onTap: _pickLogo,
                ),
              ),
            ],
          ),

          SizedBox(height: 24.h),

          /// ================= Gym Photos =================
          AppText(
            'Gym Photos',
            style: font14w500.copyWith(color: const Color(0xff364153)),
          ),
          SizedBox(height: 12.h),

          Wrap(
            spacing: 12.w,
            runSpacing: 12.h,
            children: [
              if (_gymImages.length < 6)
                GestureDetector(
                  onTap: _pickGymImages,
                  child: Container(
                    height: 100.h,
                    width: 100.w,
                    decoration: BoxDecoration(
                      color: const Color(0xffF9FAFB),
                      borderRadius: BorderRadius.circular(16.r),
                      border: Border.all(color: const Color(0xffE5E7EB)),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.image_outlined,
                          size: 28.sp,
                          color: const Color(0xff9CA3AF),
                        ),
                        SizedBox(height: 6.h),
                        AppText(
                          'Add Photo',
                          style: font12w400.copyWith(
                            color: const Color(0xff9CA3AF),
                          ),
                          alignment: AlignmentDirectional.center,
                        ),
                      ],
                    ),
                  ),
                ),

              ..._gymImages.map(
                (image) => Stack(
                  children: [
                    Container(
                      height: 90.h,
                      width: 90.w,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16.r),
                        image: DecorationImage(
                          image: FileImage(image),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 4,
                      right: 4,
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _gymImages.remove(image);
                          });
                        },
                        child: Container(
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.black54,
                          ),
                          padding: const EdgeInsets.all(4),
                          child: const Icon(
                            Icons.close,
                            size: 14,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: 12.h),

          AppText(
            'Upload up to 6 photos',
            style: font12w400.copyWith(color: const Color(0xff9CA3AF)),
          ),

          SizedBox(height: 24.h),

          AppText(
            'Address',
            style: font14w500.copyWith(color: const Color(0xff364153)),
          ),
          SizedBox(height: 8.h),
          AppFormField(
            controller: addresscontroller,
            hintText: 'Enter full address',
            maxLines: 4,
            prefixIcon: Padding(
              padding: EdgeInsets.only(left: 8.w, bottom: 78.h),
              child: Icon(Icons.location_on_outlined, size: 22.sp),
            ),
            radius: 22.r,
          ),

          SizedBox(height: 24.h),
          const LocationOnMapCard(),
          SizedBox(height: 24.h),

          GymTypeSelector(onChanged: (value) {}),
          SizedBox(height: 24.h),

          /// ================= Continue Button =================
          AppButton(
            text: 'Complete Registration',
            onPressed: () {
              GoRouter.of(context).push(Routes.mainNavigationScreen);
            },
            textSize: 14.sp,
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF0EA5E9), Color(0xFF0284C7)],
            ),
          ),
          SizedBox(height: 24.h),
        ],
      ),
    );
  }
}
