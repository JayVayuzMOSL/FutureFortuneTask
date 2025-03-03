import 'package:future_fortune_task/features/auth/data/models/user_model.dart';

abstract class AuthRepository {
  Future<UserModel> signUp(String email, String password);
  Future<UserModel> login(String email, String password);
  Future<void> logout();
  Future<UserModel?> getCurrentUser();
}