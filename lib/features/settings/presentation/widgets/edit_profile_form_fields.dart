import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gymbook/features/settings/presentation/widgets/editable_text_field.dart';

class EditProfileFormFields extends StatelessWidget {
  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final TextEditingController phoneController;
  final TextEditingController emailController;

  final bool isFirstNameEditable;
  final bool isLastNameEditable;
  final bool isPhoneEditable;

  final FocusNode firstNameFocus;
  final FocusNode lastNameFocus;
  final FocusNode phoneFocus;
  final FocusNode emailFocus;

  final VoidCallback onFirstNameEditTap;
  final VoidCallback onLastNameEditTap;
  final VoidCallback onPhoneEditTap;

  const EditProfileFormFields({
    super.key,
    required this.firstNameController,
    required this.lastNameController,
    required this.phoneController,
    required this.emailController,
    required this.isFirstNameEditable,
    required this.isLastNameEditable,
    required this.isPhoneEditable,
    required this.firstNameFocus,
    required this.lastNameFocus,
    required this.phoneFocus,
    required this.emailFocus,
    required this.onFirstNameEditTap,
    required this.onLastNameEditTap,
    required this.onPhoneEditTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        EditableTextField(
          label: "First Name",
          controller: firstNameController,
          icon: Icons.person_outline,
          inputType: TextInputType.name,
          isEditable: isFirstNameEditable,
          focusNode: firstNameFocus,
          onEditTap: onFirstNameEditTap,
        ),
        SizedBox(height: 16.h),
        EditableTextField(
          label: "Last Name",
          controller: lastNameController,
          icon: Icons.person_outline,
          inputType: TextInputType.name,
          isEditable: isLastNameEditable,
          focusNode: lastNameFocus,
          onEditTap: onLastNameEditTap,
        ),
        SizedBox(height: 16.h),
        EditableTextField(
          label: "Phone Number",
          controller: phoneController,
          prefixWidget: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Text('🇪🇬', style: TextStyle(fontSize: 16.sp))],
          ),
          inputType: TextInputType.phone,
          isEditable: isPhoneEditable,
          focusNode: phoneFocus,
          onEditTap: onPhoneEditTap,
        ),
        SizedBox(height: 16.h),
        EditableTextField(
          label: "Email",
          controller: emailController,
          icon: Icons.email_outlined,
          inputType: TextInputType.emailAddress,
          isEditable: false,
          focusNode: emailFocus,
        ),
      ],
    );
  }
}
