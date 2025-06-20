import 'package:hive_flutter/hive_flutter.dart';
import 'package:new_project_flutter/features/auth/data/model/auth_user_model.dart';
// import '../../data/models/auth_user_model.dart';

Future<void> setupHive() async {
  await Hive.initFlutter();
  Hive.registerAdapter(AuthUserModelAdapter());
  await Hive.openBox<AuthUserModel>('users');
}
