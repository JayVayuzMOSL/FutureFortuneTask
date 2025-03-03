import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:future_fortune_task/config/routes/app_route_names.dart';
import 'package:future_fortune_task/core/constants/app_strings.dart';
import 'package:future_fortune_task/core/constants/app_colors.dart';
import 'package:future_fortune_task/features/auth/presentation/bloc/auth_cubit.dart';
import 'package:future_fortune_task/features/auth/presentation/widgets/custom_button.dart';
import 'package:future_fortune_task/features/auth/presentation/widgets/custom_textform_field.dart';

class SignUpPage extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _fullNameController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void _signUp(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      context.read<AuthCubit>().signUpUser(_emailController.text, _passwordController.text);
    }
  }

  String? _validateFullName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppStrings.fullNameRequired;
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppStrings.emailRequired;
    }
    if (!RegExp(AppStrings.emailRegex).hasMatch(value)) {
      return AppStrings.invalidEmail;
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return AppStrings.passwordRequired;
    }
    if (value.length < 6) {
      return AppStrings.passwordTooShort;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthCubit, AuthState>(
        bloc: context.read<AuthCubit>(),
        listener: (context, state) {
          if (state is AuthAuthenticated) {
            Navigator.pushReplacementNamed(context, AppRouteNames.homeRoute);
          } else if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.errorColor,
              ),
            );
          }
        },
        builder: (context, state) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppStrings.signUp,
                    style: TextStyle(
                      fontSize: 28.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryTextColor,
                    ),
                  ),
                  SizedBox(height: 20.h),
                  CustomTextField(
                    hintText: AppStrings.fullName,
                    textEditingController: _fullNameController,
                    validator: _validateFullName,
                  ),
                  SizedBox(height: 15.h),
                  CustomTextField(
                    hintText: AppStrings.email,
                    textEditingController: _emailController,
                    validator: _validateEmail,
                  ),
                  SizedBox(height: 15.h),
                  CustomTextField(
                    hintText: AppStrings.password,
                    isPassword: true,
                    textEditingController: _passwordController,
                    validator: _validatePassword,
                  ),
                  SizedBox(height: 25.h),
                  state is AuthLoading
                      ? const CircularProgressIndicator()
                      : CustomButton(
                    text: AppStrings.signUp,
                    onPressed: () => _signUp(context),
                  ),
                  SizedBox(height: 15.h),
                  Center(
                    child: TextButton(
                      onPressed: () => Navigator.pushNamed(context, AppRouteNames.loginRoute),
                      child: Text(
                        AppStrings.alreadyHaveAccount,
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: AppColors.primaryColor,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
