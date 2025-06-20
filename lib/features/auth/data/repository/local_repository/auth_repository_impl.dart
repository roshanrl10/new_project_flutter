import 'package:hive/hive.dart';
import 'package:new_project_flutter/features/auth/data/model/auth_user_model.dart';
import 'package:new_project_flutter/features/auth/domain/entity/user_entity.dart';
import 'package:new_project_flutter/features/auth/domain/repository/auth_repository.dart';
// import '../../domain/entities/auth_user_entity.dart';
// import '../../domain/repositories/auth_repository.dart';
// import 'auth_user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final Box<AuthUserModel> userBox;

  AuthRepositoryImpl(this.userBox);

  @override
  Future<void> registerUser(AuthUser user) async {
    final userModel = AuthUserModel.fromEntity(user);
    await userBox.put(user.email, userModel); // Email as key
  }

  @override
  Future<bool> loginUser(String email, String password) async {
    final user = userBox.get(email);
    return user != null && user.password == password;
  }
}
