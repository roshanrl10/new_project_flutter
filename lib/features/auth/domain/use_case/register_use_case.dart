import '../repository/auth_repository.dart';
import '../entity/auth_user.dart';

class RegisterUseCase {
  final AuthRepository repository;

  RegisterUseCase(this.repository);

  Future<AuthUser> call(
    String username,
    String email,
    String password, {
    String? firstName,
    String? lastName,
  }) async {
    return await repository.register(
      username,
      email,
      password,
      firstName: firstName,
      lastName: lastName,
    );
  }
}
