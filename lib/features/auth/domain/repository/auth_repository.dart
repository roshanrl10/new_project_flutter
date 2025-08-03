import '../entity/auth_user.dart';

abstract class AuthRepository {
  Future<AuthUser> login(String email, String password);
  Future<AuthUser> register(
    String username,
    String email,
    String password, {
    String? firstName,
    String? lastName,
  });
  Future<void> logout();
  Future<String?> getToken();
  Future<AuthUser?> getCurrentUser();
  Future<bool> isLoggedIn();
}
