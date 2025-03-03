import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:future_fortune_task/features/auth/data/models/user_model.dart';
import 'package:future_fortune_task/features/auth/domain/usecases/get_user_usecase.dart';
import 'package:future_fortune_task/features/auth/domain/usecases/login_usecase.dart';
import 'package:future_fortune_task/features/auth/domain/usecases/signup_usecase.dart';

part 'auth_state.dart';

// Authentication Cubit
class AuthCubit extends Cubit<AuthState> {
  final SignUpUseCase signUp;
  final LoginUseCase login;
  final GetCurrentUserUseCase getCurrentUser;

  AuthCubit({
    required this.signUp,
    required this.login,
    required this.getCurrentUser,
  }) : super(AuthInitial());

  Future<void> signUpUser(String email, String password) async {
    emit(AuthLoading());
    try {
      final user = await signUp(email, password);
      emit(AuthAuthenticated(user));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> loginUser(String email, String password) async {
    emit(AuthLoading());
    try {
      final user = await login(email, password);
      emit(AuthAuthenticated(user));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  void checkAuthStatus() async {
    final user = await getCurrentUser();
    if (user != null) {
      emit(AuthAuthenticated(user));
    } else {
      emit(AuthUnauthenticated());
    }
  }
}
