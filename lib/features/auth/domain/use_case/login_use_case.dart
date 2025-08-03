import '../repository/auth_repository.dart';
import '../entity/auth_user.dart';

class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  Future<AuthUser> call(String email, String password) async {
    return await repository.login(email, password);
  }
}
