import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:future_fortune_task/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:future_fortune_task/features/home/presentation/bloc/add_item_cubit.dart';
import 'package:future_fortune_task/features/home/presentation/bloc/edit_task_cubit.dart';
import 'package:future_fortune_task/features/home/presentation/bloc/home_cubit.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'config/routes/app_routes.dart';

final getIt = GetIt.instance;

void setupLocator() {
  GetIt.I.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);
  GetIt.I.registerLazySingleton<FirebaseFirestore>(() => FirebaseFirestore.instance);

  GetIt.I.registerLazySingleton<AuthCubit>(
        () => AuthCubit(GetIt.I<FirebaseAuth>(), GetIt.I<FirebaseFirestore>()),
  );
  GetIt.I.registerLazySingleton<HomeCubit>(() => HomeCubit());
  GetIt.I.registerLazySingleton<AddItemCubit>(() => AddItemCubit());
  GetIt.I.registerLazySingleton<EditTaskCubit>(() => EditTaskCubit());
}


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  setupLocator();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690), // Adjust according to your design
      builder: (context, child) {
        return MultiBlocProvider(
          providers: [
            BlocProvider<AuthCubit>(create: (context) => getIt<AuthCubit>()),
            BlocProvider<HomeCubit>(create: (context) => getIt<HomeCubit>()),
            BlocProvider<AddItemCubit>(create: (context) => getIt<AddItemCubit>()),
            BlocProvider<EditTaskCubit>(create: (context) => getIt<EditTaskCubit>()),
          ],
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Future Fortune Task',
            theme: ThemeData.light(),
            darkTheme: ThemeData.dark(),
            themeMode: ThemeMode.system,
            initialRoute: '/',
            onGenerateRoute: AppRoutes.onGenerateRoute,
          ),
        );
      },
    );
  }
}
