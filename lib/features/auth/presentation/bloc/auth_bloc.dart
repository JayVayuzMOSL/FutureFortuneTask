import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'auth_state.dart';

// Authentication Cubit
class AuthCubit extends Cubit<AuthState> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  AuthCubit() : super(AuthInitial());

  // Sign Up
  Future<void> signUp(String email, String password) async {
    emit(AuthLoading());
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
      emit(AuthAuthenticated(_firebaseAuth.currentUser!));
    } on FirebaseAuthException catch (e) {
      emit(AuthError(e.message ?? "Sign-up failed"));
    }
  }

  // Login
  Future<void> login(String email, String password) async {
    emit(AuthLoading());
    try {
      await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      emit(AuthAuthenticated(_firebaseAuth.currentUser!));
    } on FirebaseAuthException catch (e) {
      emit(AuthError(e.message ?? "Login failed"));
    }
  }

  // Logout
  Future<void> logout() async {
    await _firebaseAuth.signOut();
    emit(AuthUnauthenticated());
  }

  // Check Authentication Status
  void checkAuthStatus() {
    final user = _firebaseAuth.currentUser;
    if (user != null) {
      emit(AuthAuthenticated(user));
    } else {
      emit(AuthUnauthenticated());
    }
  }
}
