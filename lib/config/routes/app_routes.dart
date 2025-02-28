import 'package:flutter/material.dart';
import 'package:future_fortune_task/features/auth/presentation/pages/login_page.dart';
import 'package:future_fortune_task/features/auth/presentation/pages/signup_page.dart';
import 'package:future_fortune_task/features/home/presentation/pages/home_page.dart';

class AppRoutes {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => LoginPage());
      case '/home':
        return MaterialPageRoute(builder: (_) => HomePage());
      case '/signup':
        return MaterialPageRoute(builder: (_) => SignUpPage());
      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('Page not found')),
          ),
        );
    }
  }
}