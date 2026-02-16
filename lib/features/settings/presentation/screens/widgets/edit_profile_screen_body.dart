import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:gymbook/core/constants/app_assets.dart';
import 'package:gymbook/core/widgets/appbar_subscription_widget.dart';
import 'package:gymbook/core/widgets/custom_button.dart';
import 'package:gymbook/core/widgets/custom_snack_bar.dart';
import 'package:gymbook/features/settings/presentation/screens/widgets/editable_profile_image.dart';
import 'package:gymbook/features/settings/presentation/screens/widgets/editable_text_field.dart';

class EditProfileScreenBody extends StatefulWidget {
  const EditProfileScreenBody({super.key});

  @override
  State<EditProfileScreenBody> createState() => _EditProfileScreenBodyState();
}

class _EditProfileScreenBodyState extends State<EditProfileScreenBody> {
  bool _isNameEditable = false;
  bool _isEmailEditable = false;
  bool _isPhoneEditable = false;

  final FocusNode _nameFocus = FocusNode();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _phoneFocus = FocusNode();

  @override
  void dispose() {
    _nameFocus.dispose();
    _emailFocus.dispose();
    _phoneFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        children: [
          AppbarSubscriptionWidget(
            text: 'Mostafa Hussein',
            onBack: () {
              GoRouter.of(context).pop();
            },
          ),
          SizedBox(height: 32.h),

          const EditableProfileImage(image: Assets.gym1),
          SizedBox(height: 32.h),

          EditableTextField(
            label: "Full Name",
            initialValue: "Mostafa Hussein",
            icon: Icons.person_outline,
            inputType: TextInputType.name,
            isEditable: _isNameEditable,
            focusNode: _nameFocus,
            onEditTap: () {
              setState(() {
                _isNameEditable = !_isNameEditable;
                if (_isNameEditable) _nameFocus.requestFocus();
              });
            },
          ),
          SizedBox(height: 16.h),

          EditableTextField(
            label: "Email",
            initialValue: "mostafa.hussein@gmail.com",
            icon: Icons.email_outlined,
            inputType: TextInputType.emailAddress,
            isEditable: _isEmailEditable,
            focusNode: _emailFocus,
            onEditTap: () {
              setState(() {
                _isEmailEditable = !_isEmailEditable;
                if (_isEmailEditable) _emailFocus.requestFocus();
              });
            },
          ),
          SizedBox(height: 16.h),

          EditableTextField(
            label: "Phone Number",
            initialValue: "+20 1013289244",
            icon: Icons.phone_outlined,
            inputType: TextInputType.phone,
            isEditable: _isPhoneEditable,
            focusNode: _phoneFocus,
            onEditTap: () {
              setState(() {
                _isPhoneEditable = !_isPhoneEditable;
                if (_isPhoneEditable) _phoneFocus.requestFocus();
              });
            },
          ),

          SizedBox(height: 32.h),

          AppButton(
            text: "Update Profile",
            color: const Color(0xFF0EA5E9),
            height: 50.h,
            textSize: 16.sp,
            onPressed: () {
              FocusScope.of(context).unfocus();
              setState(() {
                _isNameEditable = false;
                _isEmailEditable = false;
                _isPhoneEditable = false;
              });
              CustomSnackBar.showSuccess(
                context,
                message: "Profile updated successfully!",
              );
            },
            margin: EdgeInsets.symmetric(horizontal: 12.w),
          ),
        ],
      ),
    );
  }
}
