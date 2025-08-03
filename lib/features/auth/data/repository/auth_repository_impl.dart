import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../../domain/repository/auth_repository.dart';
import '../../domain/entity/auth_user.dart';
import '../data_source/remote_datasource/auth_remote_datasource.dart';
// import '../model/api_user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  static const String _tokenKey = 'auth_token';
  static const String _userKey = 'auth_user';

  AuthRepositoryImpl(this.remoteDataSource);

  @override
  Future<AuthUser> login(String email, String password) async {
    try {
      final apiUser = await remoteDataSource.login(email, password);
      final authUser = apiUser.toEntity();

      // Save token and user data locally
      await _saveToken(authUser.token);
      await _saveUser(authUser);

      return authUser;
    } catch (e) {
      throw Exception('Login failed: $e');
    }
  }

  @override
  Future<AuthUser> register(
    String username,
    String email,
    String password, {
    String? firstName,
    String? lastName,
  }) async {
    try {
      final apiUser = await remoteDataSource.register(
        username,
        email,
        password,
        firstName: firstName,
        lastName: lastName,
      );

      final authUser = apiUser.toEntity();

      // For registration, we might not get a token back
      // The user will need to login after registration
      return authUser;
    } catch (e) {
      throw Exception('Registration failed: $e');
    }
  }

  @override
  Future<void> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_tokenKey);
      await prefs.remove(_userKey);
    } catch (e) {
      throw Exception('Logout failed: $e');
    }
  }

  @override
  Future<String?> getToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_tokenKey);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<AuthUser?> getCurrentUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userJson = prefs.getString(_userKey);
      if (userJson != null) {
        final userMap = json.decode(userJson) as Map<String, dynamic>;
        return AuthUser.fromJson(userMap);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<bool> isLoggedIn() async {
    try {
      final token = await getToken();
      return token != null && token.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  Future<void> _saveToken(String? token) async {
    if (token != null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_tokenKey, token);
    }
  }

  Future<void> _saveUser(AuthUser user) async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = json.encode(user.toJson());
    await prefs.setString(_userKey, userJson);
  }
}
