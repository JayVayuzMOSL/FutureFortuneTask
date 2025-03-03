import 'package:future_fortune_task/features/auth/domain/repositories/auth_repository.dart';
import 'package:future_fortune_task/features/auth/data/models/user_model.dart';

class LoginUseCase {
  final AuthRepository repository;
  LoginUseCase(this.repository);
  Future<UserModel> call(String email, String password) {
    return repository.login(email, password);
  }
}