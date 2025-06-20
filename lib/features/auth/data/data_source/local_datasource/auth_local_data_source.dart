import 'package:new_project_flutter/core/utils/hive_service.dart';
import 'package:new_project_flutter/features/auth/data/model/auth_user_model.dart';
import 'package:new_project_flutter/features/auth/domain/entity/user_entity.dart';
// import 'package:new_project_flutter/features/auth/data/datasources/hive_service.dart';

abstract class IAuthLocalDataSource {
  Future<void> registerUser(AuthUser user);
  Future<AuthUser?> loginUser(String email, String password);
  // Add other local data source methods here if needed
}

class AuthLocalDataSource implements IAuthLocalDataSource {
  final HiveService _hiveService;

  AuthLocalDataSource({required HiveService hiveService})
    : _hiveService = hiveService;

  @override
  Future<void> registerUser(AuthUser user) async {
    try {
      final normalizedEmail = user.email.trim().toLowerCase();
      final authUserModel = AuthUserModel.fromEntity(user);
      await _hiveService.register(normalizedEmail, authUserModel);
    } catch (e) {
      throw Exception("Registration failed: $e");
    }
  }

  @override
  Future<AuthUser?> loginUser(String email, String password) async {
    try {
      final normalizedEmail = email.trim().toLowerCase();
      final authUserModel = await _hiveService.login(normalizedEmail, password);
      if (authUserModel != null && authUserModel.password == password) {
        return authUserModel.toEntity();
      } else {
        return null;
      }
    } catch (e) {
      throw Exception("Login failed: $e");
    }
  }
}
