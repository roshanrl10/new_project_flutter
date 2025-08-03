import 'package:hive/hive.dart';
import 'package:new_project_flutter/features/auth/domain/entity/user_entity.dart';

part 'auth_user_model.g.dart';

@HiveType(typeId: 0)
class AuthUserModel extends HiveObject {
  @HiveField(0)
  final String email;

  @HiveField(1)
  final String password;

  AuthUserModel({required this.email, required this.password});

  /// ✅ Convert from domain entity to model
  factory AuthUserModel.fromEntity(AuthUser user) {
    return AuthUserModel(email: user.email, password: user.password);
  }

  /// ✅ Convert from model to domain entity
  AuthUser toEntity() {
    return AuthUser(email: email, password: password);
  }
}
