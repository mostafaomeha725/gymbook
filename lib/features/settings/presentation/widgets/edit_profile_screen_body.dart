import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:gymbook/core/utils/easy_loading.dart';
import 'package:gymbook/core/widgets/appbar_subscription_widget.dart';
import 'package:gymbook/core/widgets/custom_button.dart';
import 'package:gymbook/features/settings/presentation/cubits/edit_profile_cubit/edit_profile_cubit.dart';
import 'package:gymbook/features/settings/presentation/cubits/edit_profile_cubit/edit_profile_state.dart';
import 'package:gymbook/features/settings/presentation/widgets/edit_profile_avatar.dart';
import 'package:gymbook/features/settings/presentation/widgets/edit_profile_form_fields.dart';

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
  final FocusNode _emailFocus = FocusNode();

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  @override
  void dispose() {
    _firstNameFocus.dispose();
    _lastNameFocus.dispose();
    _phoneFocus.dispose();
    _emailFocus.dispose();

    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
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
    _emailController.text = email;

    String displayPhone = phone;
    if (displayPhone.startsWith('+20')) {
      displayPhone = '0${displayPhone.substring(3)}';
    } else if (displayPhone.startsWith('20')) {
      displayPhone = '0${displayPhone.substring(2)}';
    }
    _phoneController.text = displayPhone;
  }

  void _onUpdateProfile() {
    FocusScope.of(context).unfocus();

    String? phoneToSubmit = _phoneController.text.trim();
    if (phoneToSubmit.isEmpty) {
      phoneToSubmit = null;
    } else {
      if (phoneToSubmit.startsWith('0')) {
        phoneToSubmit = '+20${phoneToSubmit.substring(1)}';
      } else if (!phoneToSubmit.startsWith('+')) {
        phoneToSubmit = '+20$phoneToSubmit';
      }
    }

    context.read<EditProfileCubit>().updateProfile(
      firstName: _firstNameController.text.trim(),
      lastName: _lastNameController.text.trim(),
      phoneNumber: phoneToSubmit,
    );
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

              EditProfileAvatar(
                firstName: _firstNameController.text,
                lastName: _lastNameController.text,
                isLoading: state is EditProfileUpdating,
              ),
              SizedBox(height: 32.h),

              EditProfileFormFields(
                firstNameController: _firstNameController,
                lastNameController: _lastNameController,
                phoneController: _phoneController,
                emailController: _emailController,
                isFirstNameEditable: _isFirstNameEditable,
                isLastNameEditable: _isLastNameEditable,
                isPhoneEditable: _isPhoneEditable,
                firstNameFocus: _firstNameFocus,
                lastNameFocus: _lastNameFocus,
                phoneFocus: _phoneFocus,
                emailFocus: _emailFocus,
                onFirstNameEditTap: () {
                  setState(() {
                    _isFirstNameEditable = !_isFirstNameEditable;
                    if (_isFirstNameEditable) _firstNameFocus.requestFocus();
                  });
                },
                onLastNameEditTap: () {
                  setState(() {
                    _isLastNameEditable = !_isLastNameEditable;
                    if (_isLastNameEditable) _lastNameFocus.requestFocus();
                  });
                },
                onPhoneEditTap: () {
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
                onPressed: _onUpdateProfile,
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
