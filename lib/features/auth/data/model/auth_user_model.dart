import 'package:hive/hive.dart';
import 'package:new_project_flutter/features/auth/domain/entity/user_entity.dart';
// import '../../domain/entities/auth_user_entity.dart';

part 'auth_user_model.g.dart';

@HiveType(typeId: 0)
class AuthUserModel extends HiveObject {
  @HiveField(0)
  String email;

  @HiveField(1)
  String password;

  AuthUserModel({required this.email, required this.password});

  factory AuthUserModel.fromEntity(AuthUser user) {
    return AuthUserModel(email: user.email, password: user.password);
  }

  AuthUser toEntity() {
    return AuthUser(email: email, password: password);
  }
}
