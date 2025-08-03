import '../../../../../core/network/api_service.dart';
import '../../../../../app/constant/api_endpoints.dart';
import '../../model/api_user_model.dart';

abstract class AuthRemoteDataSource {
  Future<ApiUserModel> login(String email, String password);
  Future<ApiUserModel> register(
    String username,
    String email,
    String password, {
    String? firstName,
    String? lastName,
  });
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiService _apiService = ApiService();

  @override
  Future<ApiUserModel> login(String email, String password) async {
    try {
      print('🔐 Attempting login for: $email');

      final response = await _apiService.post(
        ApiEndpoints.login,
        data: {'email': email, 'password': password},
      );

      print('📡 Login response status: ${response.statusCode}');
      print('📡 Login response data: ${response.data}');

      if (response.statusCode == 200) {
        final data = response.data;

        if (data['success'] == true) {
          final userData = data['data'];
          final token = data['token'];

          print('✅ Login successful for user: ${userData['username']}');

          return ApiUserModel(
            id: userData['_id']?.toString() ?? '',
            username: userData['username']?.toString() ?? '',
            email: userData['email']?.toString() ?? '',
            firstName: userData['firstName']?.toString(),
            lastName: userData['lastName']?.toString(),
            token: token?.toString(),
            role: userData['role']?.toString() ?? 'normal',
            createdAt: DateTime.parse(
              userData['createdAt'] ?? DateTime.now().toIso8601String(),
            ),
            updatedAt: DateTime.parse(
              userData['updatedAt'] ?? DateTime.now().toIso8601String(),
            ),
          );
        } else {
          print('❌ Login failed: ${data['message']}');
          throw Exception(data['message'] ?? 'Login failed');
        }
      } else {
        print(
          '❌ HTTP Error: ${response.statusCode} - ${response.statusMessage}',
        );
        throw Exception('Login failed: ${response.statusMessage}');
      }
    } catch (e) {
      print('💥 Exception in login: $e');
      print('💥 Exception type: ${e.runtimeType}');
      throw Exception('Login failed: $e');
    }
  }

  @override
  Future<ApiUserModel> register(
    String username,
    String email,
    String password, {
    String? firstName,
    String? lastName,
  }) async {
    try {
      print('🔐 Attempting registration for: $email');

      final response = await _apiService.post(
        ApiEndpoints.register,
        data: {
          'username': username,
          'email': email,
          'password': password,
          'firstName': firstName,
          'lastName': lastName,
        },
      );

      print('📡 Registration response status: ${response.statusCode}');
      print('📡 Registration response data: ${response.data}');

      if (response.statusCode == 201 || response.statusCode == 200) {
        final data = response.data;

        if (data['success'] == true) {
          print('✅ Registration successful for user: $username');

          // For registration, we return a user model without token
          // The user will need to login to get a token
          return ApiUserModel(
            id: '', // Will be set after login
            username: username,
            email: email,
            firstName: firstName,
            lastName: lastName,
            token: null, // No token on registration
            role: 'normal',
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          );
        } else {
          print('❌ Registration failed: ${data['message']}');
          throw Exception(data['message'] ?? 'Registration failed');
        }
      } else {
        print(
          '❌ HTTP Error: ${response.statusCode} - ${response.statusMessage}',
        );
        throw Exception('Registration failed: ${response.statusMessage}');
      }
    } catch (e) {
      print('💥 Exception in registration: $e');
      print('💥 Exception type: ${e.runtimeType}');
      throw Exception('Registration failed: $e');
    }
  }
}
