import 'package:flutter/material.dart';
import 'package:future_fortune_task/config/routes/app_route_names.dart';
import 'package:future_fortune_task/features/auth/presentation/pages/login_page.dart';
import 'package:future_fortune_task/features/auth/presentation/pages/signup_page.dart';
import 'package:future_fortune_task/features/home/data/models/note_model.dart';
import 'package:future_fortune_task/features/home/presentation/pages/add_item_page.dart';
import 'package:future_fortune_task/features/home/presentation/pages/edit_item_page.dart';
import 'package:future_fortune_task/features/home/presentation/pages/home_page.dart';

class AppRoutes {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRouteNames.loginRoute:
        return MaterialPageRoute(builder: (_) => LoginPage());
      case AppRouteNames.homeRoute:
        return MaterialPageRoute(builder: (_) => HomePage());
      case AppRouteNames.signupRoute:
        return MaterialPageRoute(builder: (_) => SignUpPage());
      case AppRouteNames.addItemRoute:
        return MaterialPageRoute(builder: (_) => AddItemPage());
      case AppRouteNames.editItemRoute:
        NoteModel noteModel = settings.arguments as NoteModel;
        return MaterialPageRoute(builder: (_) => EditTaskPage(noteModel: noteModel));
      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('Page not found')),
          ),
        );
    }
  }
}