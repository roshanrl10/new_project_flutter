import 'package:hive/hive.dart';
import 'package:new_project_flutter/features/auth/data/model/auth_user_model.dart';

class HiveService {
  final Box<AuthUserModel> userBox;

  HiveService(this.userBox);

  Future<void> register(String emailKey, AuthUserModel userModel) async {
    await userBox.put(emailKey, userModel);
  }

  Future<AuthUserModel?> login(String emailKey, String password) async {
    final userModel = userBox.get(emailKey);
    return userModel;
  }
}
