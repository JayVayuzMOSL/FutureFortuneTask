import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:future_fortune_task/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:future_fortune_task/features/auth/presentation/widgets/custom_button.dart';
import 'package:future_fortune_task/features/auth/presentation/widgets/custom_textform_field.dart';
import 'package:get_it/get_it.dart';

class LoginPage extends StatelessWidget {

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _login() {
    GetIt.I<AuthCubit>().login(_emailController.text, _passwordController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthCubit, AuthState>(
          bloc: GetIt.I<AuthCubit>(),
          listener: (context, state) {
            if (state is AuthAuthenticated) {
              Navigator.pushReplacementNamed(context, '/home');
            } else if (state is AuthError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
          },
          builder: (context, state) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Login", style: TextStyle(fontSize: 28.sp, fontWeight: FontWeight.bold)),
                SizedBox(height: 20.h),
                CustomTextField(hintText: "Email", textEditingController: _emailController,),
                SizedBox(height: 15.h),
                CustomTextField(hintText: "Password", isPassword: true, textEditingController: _passwordController,),
                SizedBox(height: 25.h),
                state is AuthLoading
                    ? const CircularProgressIndicator()
                    : CustomButton(text: "Login", onPressed: _login),
                SizedBox(height: 15.h),
                Center(
                  child: TextButton(
                    onPressed: () => Navigator.pushNamed(context, '/signup'),
                    child: Text("Don't have an account? Sign Up", style: TextStyle(fontSize: 14.sp)),
                  ),
                )
              ],
            ),
          );
        }
      ),
    );
  }
}
