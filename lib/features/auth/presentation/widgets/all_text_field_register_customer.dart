import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:gymbook/core/routes/route_paths.dart';
import 'package:gymbook/core/theme/styles.dart';
import 'package:gymbook/core/utils/easy_loading.dart';
import 'package:gymbook/core/widgets/app_form_field.dart';
import 'package:gymbook/core/widgets/custom_button.dart';
import 'package:gymbook/core/widgets/custom_text.dart';
import 'package:gymbook/features/auth/presentation/cubits/register_cubit/register_cubit.dart';
import 'package:gymbook/features/auth/presentation/widgets/password_condition_widget.dart';

class AllTextFieldRegisterCustomer extends StatefulWidget {
  const AllTextFieldRegisterCustomer({super.key});

  @override
  State<AllTextFieldRegisterCustomer> createState() =>
      _AllTextFieldRegisterCustomerState();
}

class _AllTextFieldRegisterCustomerState
    extends State<AllTextFieldRegisterCustomer> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  bool obscurePassword = true;
  bool obscureConfirmPassword = true;

  @override
  void initState() {
    super.initState();
    passwordController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    addressController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  String? _required(String? v, String label) {
    if (v == null || v.trim().isEmpty) return 'Please enter $label';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<RegisterCubit, RegisterState>(
      listener: (context, state) {
        if (state is RegisterSuccess) {
          hideLoading();
          showSuccess('Account created successfully!');
          GoRouter.of(context).go(Routes.otpScreen);
        }
      },
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 52.h),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText(
                'First Name',
                style: font14w500.copyWith(color: const Color(0xff364153)),
              ),
              SizedBox(height: 8.h),
              AppFormField(
                controller: firstNameController,
                hintText: 'Enter your first name',
                maxLines: 1,
                prefixIcon: Padding(
                  padding: EdgeInsets.only(left: 8.w),
                  child: Icon(Icons.person_outline, size: 22.sp),
                ),
                radius: 22.r,
                validator: (v) => _required(v, 'your first name'),
              ),

              SizedBox(height: 16.h),

              AppText(
                'Last Name',
                style: font14w500.copyWith(color: const Color(0xff364153)),
              ),
              SizedBox(height: 8.h),
              AppFormField(
                controller: lastNameController,
                hintText: 'Enter your last name',
                maxLines: 1,
                prefixIcon: Padding(
                  padding: EdgeInsets.only(left: 8.w),
                  child: Icon(Icons.person_outline, size: 22.sp),
                ),
                radius: 22.r,
                validator: (v) => _required(v, 'your last name'),
              ),

              SizedBox(height: 16.h),

              AppText(
                'Email',
                style: font14w500.copyWith(color: const Color(0xff364153)),
              ),
              SizedBox(height: 8.h),
              AppFormField(
                controller: emailController,
                hintText: 'Enter your email',
                maxLines: 1,
                keyboardType: TextInputType.emailAddress,
                prefixIcon: Padding(
                  padding: EdgeInsets.only(left: 8.w),
                  child: Icon(Icons.email_outlined, size: 22.sp),
                ),
                radius: 22.r,
                validator: (v) {
                  if (v == null || v.trim().isEmpty) {
                    return 'Please enter your email';
                  }

                  return null;
                },
              ),

              SizedBox(height: 16.h),

              AppText(
                'Phone Number',
                style: font14w500.copyWith(color: const Color(0xff364153)),
              ),
              SizedBox(height: 8.h),
              AppFormField(
                controller: phoneController,
                hintText: '+20 XXX XXX XXX',
                maxLines: 1,
                keyboardType: TextInputType.phone,
                prefixIcon: Padding(
                  padding: EdgeInsets.only(left: 8.w),
                  child: Icon(Icons.phone_outlined, size: 22.sp),
                ),
                radius: 22.r,
                validator: (v) => _required(v, 'your phone number'),
              ),

              SizedBox(height: 16.h),

              AppText(
                'Address (Optional)',
                style: font14w500.copyWith(color: const Color(0xff364153)),
              ),
              SizedBox(height: 8.h),
              AppFormField(
                controller: addressController,
                hintText: 'Enter your address',
                maxLines: 1,
                prefixIcon: Padding(
                  padding: EdgeInsets.only(left: 8.w),
                  child: Icon(Icons.location_on_outlined, size: 22.sp),
                ),
                radius: 22.r,
              ),

              SizedBox(height: 16.h),

              AppText(
                'Password',
                style: font14w500.copyWith(color: const Color(0xff364153)),
              ),
              SizedBox(height: 8.h),
              AppFormField(
                controller: passwordController,
                hintText: 'Create a password',
                maxLines: 1,
                obsecureText: obscurePassword,
                prefixIcon: Padding(
                  padding: EdgeInsets.only(left: 8.w),
                  child: Icon(Icons.lock_outline, size: 22.sp),
                ),
                radius: 22.r,
                suffixIcon: IconButton(
                  icon: Icon(
                    obscurePassword
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                  ),
                  onPressed: () =>
                      setState(() => obscurePassword = !obscurePassword),
                ),
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Please enter a password';

                  return null;
                },
              ),

              SizedBox(height: 8.h),

              PasswordConditionsWidget(password: passwordController.text),

              SizedBox(height: 16.h),

              AppText(
                'Confirm Password',
                style: font14w500.copyWith(color: const Color(0xff364153)),
              ),
              SizedBox(height: 8.h),
              AppFormField(
                controller: confirmPasswordController,
                hintText: 'Confirm your password',
                maxLines: 1,
                obsecureText: obscureConfirmPassword,
                prefixIcon: Padding(
                  padding: EdgeInsets.only(left: 8.w),
                  child: Icon(Icons.lock_outline, size: 22.sp),
                ),
                radius: 22.r,
                suffixIcon: IconButton(
                  icon: Icon(
                    obscureConfirmPassword
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                  ),
                  onPressed: () => setState(
                    () => obscureConfirmPassword = !obscureConfirmPassword,
                  ),
                ),
                validator: (v) {
                  if (v == null || v.isEmpty) {
                    return 'Please confirm your password';
                  }

                  return null;
                },
              ),

              SizedBox(height: 24.h),

              AppButton(
                text: 'Continue',
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    context.read<RegisterCubit>().register(
                      firstName: firstNameController.text.trim(),
                      lastName: lastNameController.text.trim(),
                      email: emailController.text.trim(),
                      password: passwordController.text,
                      confirmPassword: confirmPasswordController.text,
                      address: addressController.text.trim(),
                      phoneNumber: phoneController.text.trim(),
                    );
                  }
                },
                textSize: 16.sp,
                gradient: const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFF0EA5E9), Color(0xFF0284C7)],
                ),
              ),

              SizedBox(height: 24.h),
            ],
          ),
        ),
      ),
    );
  }
}
