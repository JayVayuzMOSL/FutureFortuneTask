import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'auth_state.dart';

// Authentication Cubit
class AuthCubit extends Cubit<AuthState> {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;

  AuthCubit(this._firebaseAuth, this._firestore) : super(AuthInitial());

  // Sign Up
  Future<void> signUp(String email, String password) async {
    emit(AuthLoading());
    try {
      UserCredential userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = userCredential.user;

      if (user != null) {
        // Store user ID in SharedPreferences
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('user_id', user.uid).then((value) async{
          await _firestore.collection('users').doc(user.uid).set({
            'email': email,
            'password': password, // Storing password as plain text is NOT recommended
            'created_at': FieldValue.serverTimestamp(),
          });
          emit(AuthAuthenticated(user));
        });
      } else {
        emit(AuthError("User creation failed"));
      }
    } on FirebaseAuthException catch (e) {
      emit(AuthError(e.message ?? "Sign-up failed"));
    }
  }

  // Login
  Future<void> login(String email, String password) async {
    emit(AuthLoading());
    try {
      // Sign in user
      UserCredential userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      User user = userCredential.user!;
      String userId = user.uid;

      // Save userId to SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('user_id', userId).then((value) async{
        emit(AuthAuthenticated(user));
      });

      // Save user data to Firestore with an auto-generated document ID
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
