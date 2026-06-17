import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:gymbook/core/constants/app_assets.dart';
import 'package:gymbook/core/utils/easy_loading.dart';
import 'package:gymbook/core/widgets/appbar_subscription_widget.dart';
import 'package:gymbook/core/widgets/custom_button.dart';
import 'package:gymbook/features/settings/presentation/cubits/edit_profile_cubit/edit_profile_cubit.dart';
import 'package:gymbook/features/settings/presentation/cubits/edit_profile_cubit/edit_profile_state.dart';
import 'package:gymbook/features/settings/presentation/widgets/editable_profile_image.dart';
import 'package:gymbook/features/settings/presentation/widgets/editable_text_field.dart';

class EditProfileScreenBody extends StatefulWidget {
  const EditProfileScreenBody({super.key});

  @override
  State<EditProfileScreenBody> createState() => _EditProfileScreenBodyState();
}

class _EditProfileScreenBodyState extends State<EditProfileScreenBody> {
  bool _isFirstNameEditable = false;
  bool _isLastNameEditable = false;
  bool _isPhoneEditable = false;

  final FocusNode _firstNameFocus = FocusNode();
  final FocusNode _lastNameFocus = FocusNode();
  final FocusNode _phoneFocus = FocusNode();

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  @override
  void dispose() {
    _firstNameFocus.dispose();
    _lastNameFocus.dispose();
    _phoneFocus.dispose();

    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _updateControllers(
    String firstName,
    String lastName,
    String email,
    String phone,
  ) {
    _firstNameController.text = firstName;
    _lastNameController.text = lastName;
    _phoneController.text = phone;
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<EditProfileCubit, EditProfileState>(
      listener: (context, state) {
        if (state is EditProfileLoaded) {
          _updateControllers(
            state.profile.firstName,
            state.profile.lastName,
            state.profile.email,
            state.profile.phoneNumber,
          );
        } else if (state is EditProfileUpdating) {
          showLoading();
        } else if (state is EditProfileUpdated) {
          hideLoading();
          showSuccess('Profile updated successfully!');
          setState(() {
            _isFirstNameEditable = false;
            _isLastNameEditable = false;
            _isPhoneEditable = false;
          });
        } else if (state is EditProfileUpdateError) {
          hideLoading();
          showError(state.message);
        } else if (state is EditProfileError) {
          showError(state.message);
        }
      },
      builder: (context, state) {
        if (state is EditProfileLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        final fullName =
            '${_firstNameController.text} ${_lastNameController.text}'.trim();

        return SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            children: [
              AppbarSubscriptionWidget(
                text: fullName.isNotEmpty ? fullName : 'Edit Profile',
                onBack: () {
                  GoRouter.of(context).pop();
                },
              ),
              SizedBox(height: 32.h),

              const EditableProfileImage(image: Assets.gym1),
              SizedBox(height: 32.h),

              EditableTextField(
                label: "First Name",
                controller: _firstNameController,
                icon: Icons.person_outline,
                inputType: TextInputType.name,
                isEditable: _isFirstNameEditable,
                focusNode: _firstNameFocus,
                onEditTap: () {
                  setState(() {
                    _isFirstNameEditable = !_isFirstNameEditable;
                    if (_isFirstNameEditable) _firstNameFocus.requestFocus();
                  });
                },
              ),
              SizedBox(height: 16.h),

              EditableTextField(
                label: "Last Name",
                controller: _lastNameController,
                icon: Icons.person_outline,
                inputType: TextInputType.name,
                isEditable: _isLastNameEditable,
                focusNode: _lastNameFocus,
                onEditTap: () {
                  setState(() {
                    _isLastNameEditable = !_isLastNameEditable;
                    if (_isLastNameEditable) _lastNameFocus.requestFocus();
                  });
                },
              ),
              SizedBox(height: 16.h),

              EditableTextField(
                label: "Phone Number",
                controller: _phoneController,
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

                  context.read<EditProfileCubit>().updateProfile(
                    firstName: _firstNameController.text.trim(),
                    lastName: _lastNameController.text.trim(),
                    phoneNumber: _phoneController.text.trim(),
                  );
                },
                margin: EdgeInsets.symmetric(horizontal: 12.w),
              ),
              SizedBox(height: 32.h),
            ],
          ),
        );
      },
    );
  }
}
