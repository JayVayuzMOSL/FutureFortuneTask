
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:future_fortune_task/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:future_fortune_task/features/auth/domain/repositories/auth_repository.dart';
import 'package:future_fortune_task/features/auth/domain/usecases/signup_usecase.dart';
import 'package:future_fortune_task/features/home/domain/repositories/note_repository.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'features/auth/domain/usecases/get_user_usecase.dart';
import 'features/auth/domain/usecases/login_usecase.dart';
import 'features/home/domain/usecases/logout_usecase.dart';
import 'features/auth/presentation/bloc/auth_cubit.dart';
import 'features/home/data/repositories/note_repository_impl.dart';
import 'features/home/domain/usecases/add_note_usecase.dart';
import 'features/home/domain/usecases/delete_note_usecase.dart';
import 'features/home/domain/usecases/fetch_note_usecase.dart';
import 'features/home/domain/usecases/update_note_usecase.dart';
import 'features/home/presentation/cubit/note_cubit.dart';

final getIt = GetIt.I;

Future<void> setupLocator() async{
  getIt.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);
  getIt.registerLazySingleton<FirebaseFirestore>(() => FirebaseFirestore.instance);
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerLazySingleton<SharedPreferences>(() => sharedPreferences);
  getIt.registerLazySingleton<NoteRepository>(() => NoteRepositoryImpl(
      getIt<FirebaseFirestore>(),
      getIt<SharedPreferences>()
  ));
  getIt.registerLazySingleton<AuthRepository>(
        () => AuthRepositoryImpl(
        getIt<FirebaseAuth>(),
        getIt<FirebaseFirestore>(),
        getIt<SharedPreferences>()
    ),
  );

  getIt.registerLazySingleton<SignUpUseCase>(
        () => SignUpUseCase(getIt<AuthRepository>()),
  );

  getIt.registerLazySingleton<LoginUseCase>(
        () => LoginUseCase(getIt<AuthRepository>()),
  );

  getIt.registerLazySingleton<LogoutUseCase>(
        () => LogoutUseCase(getIt<AuthRepository>()),
  );

  getIt.registerLazySingleton<GetCurrentUserUseCase>(
        () => GetCurrentUserUseCase(getIt<AuthRepository>()),
  );

  getIt.registerLazySingleton<AddNoteUseCase>(() => AddNoteUseCase(getIt<NoteRepository>()));
  getIt.registerLazySingleton<UpdateNoteUseCase>(() => UpdateNoteUseCase(getIt<NoteRepository>()));
  getIt.registerLazySingleton<DeleteNoteUseCase>(() => DeleteNoteUseCase(getIt<NoteRepository>()));
  getIt.registerLazySingleton<FetchNotesUseCase>(() => FetchNotesUseCase(getIt<NoteRepository>()));

  getIt.registerLazySingleton<AuthCubit>(
        () => AuthCubit(
        signUp: getIt<SignUpUseCase>(),
        login: getIt<LoginUseCase>(),
        getCurrentUser: getIt<GetCurrentUserUseCase>()
    ),
  );
  getIt.registerLazySingleton<NoteCubit>(() => NoteCubit(
    getIt<AddNoteUseCase>(),
    getIt<UpdateNoteUseCase>(),
    getIt<DeleteNoteUseCase>(),
    getIt<FetchNotesUseCase>(),
    getIt<LogoutUseCase>(),
  ));
}