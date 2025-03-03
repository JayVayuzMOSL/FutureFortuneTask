// Repository Implementation
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:future_fortune_task/features/auth/domain/repositories/auth_repository.dart';
import 'package:future_fortune_task/features/auth/data/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;
  final SharedPreferences _prefs;

  AuthRepositoryImpl(this._firebaseAuth, this._firestore, this._prefs);

  @override
  Future<UserModel> signUp(String email, String password) async {
    UserCredential userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    User user = userCredential.user!;
    await _firestore.collection('users').doc(user.uid).set({
      'email': email,
      'password': password,
      'created_at': FieldValue.serverTimestamp(),
    });

    await _prefs.setString('user_id', user.uid);
    return UserModel(uid: user.uid, email: user.email!, password: password);
  }

  @override
  Future<UserModel> login(String email, String password) async {
    UserCredential userCredential = await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    User user = userCredential.user!;
    await _prefs.setString('user_id', user.uid);
    return UserModel(uid: user.uid, email: user.email!, password: password);
  }

  @override
  Future<void> logout() async {
    await _firebaseAuth.signOut();
    await _prefs.remove('user_id');
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    String? userId = _prefs.getString('user_id');
    if (userId == null) return null;
    User? user = _firebaseAuth.currentUser;
    if (user == null) return null;
    return UserModel(uid: user.uid, email: user.email!);
  }
}