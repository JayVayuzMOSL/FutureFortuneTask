import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:future_fortune_task/core/constants/app_colors.dart';

class CustomTextField extends StatelessWidget {
  final String hintText;
  final bool isPassword;
  final TextEditingController textEditingController;
  final String? Function(String?)? validator; // Added validator

  const CustomTextField({
    super.key,
    required this.hintText,
    required this.textEditingController,
    this.isPassword = false,
    this.validator, // Initialize validator
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: textEditingController,
      obscureText: isPassword,
      validator: validator, // Apply validator
      decoration: InputDecoration(
        hintText: hintText,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.r)),
        contentPadding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 14.h),
        errorBorder: OutlineInputBorder( // Styling for error state
          borderRadius: BorderRadius.circular(10.r),
          borderSide: BorderSide(color: AppColors.errorTextColor),
        ),
        focusedErrorBorder: OutlineInputBorder( // Focused error state
          borderRadius: BorderRadius.circular(10.r),
          borderSide: BorderSide(color: AppColors.errorTextColor),
        ),
      ),
    );
  }
}