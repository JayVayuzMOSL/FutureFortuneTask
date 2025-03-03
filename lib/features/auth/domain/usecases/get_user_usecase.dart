

import 'package:future_fortune_task/features/auth/domain/repositories/auth_repository.dart';
import 'package:future_fortune_task/features/auth/data/models/user_model.dart';

class GetCurrentUserUseCase {
  final AuthRepository repository;
  GetCurrentUserUseCase(this.repository);
  Future<UserModel?> call() {
    return repository.getCurrentUser();
  }
}