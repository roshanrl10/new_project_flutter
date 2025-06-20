import 'package:new_project_flutter/features/auth/domain/entity/user_entity.dart';

abstract class AuthRepository {
  Future<void> registerUser(AuthUser user);
  Future<bool> loginUser(String email, String password);
}
