import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../app/constant/api_endpoints.dart';

class ApiClient {
  static final ApiClient _instance = ApiClient._internal();
  factory ApiClient() => _instance;
  ApiClient._internal();

  late Dio _dio;

  void initialize() {
    print('🔧 Initializing API Client...');
    print('🔧 Base URL: ${ApiEndpoints.baseUrl}');

    _dio = Dio(
      BaseOptions(
        baseUrl: ApiEndpoints.baseUrl,
        connectTimeout: ApiEndpoints.connectionTimeout,
        receiveTimeout: ApiEndpoints.receiveTimeout,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    print('🔧 Dio instance created');

    // Add interceptors
    _dio.interceptors.add(
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: true,
        error: true,
        compact: false,
        maxWidth: 90,
      ),
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          print('🌐 Making request to: ${options.uri}');
          print('🌐 Method: ${options.method}');
          print('🌐 Headers: ${options.headers}');

          // Add auth token if available
          final prefs = await SharedPreferences.getInstance();
          final token = prefs.getString('auth_token');
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
            print('🔑 Added auth token to request');
          }
          handler.next(options);
        },
        onResponse: (response, handler) async {
          print('✅ Response received: ${response.statusCode}');
          print('✅ Response data: ${response.data}');
          handler.next(response);
        },
        onError: (error, handler) async {
          print('❌ Error occurred: ${error.message}');
          print('❌ Error type: ${error.type}');
          print('❌ Error response: ${error.response?.data}');

          if (error.response?.statusCode == 401) {
            // Handle unauthorized access
            final prefs = await SharedPreferences.getInstance();
            await prefs.remove('auth_token');
            await prefs.remove('user_data');
            print('🔑 Cleared auth data due to 401 error');
          }
          handler.next(error);
        },
      ),
    );

    print('🔧 API Client initialization complete');
  }

  Dio get dio => _dio;

  void reinitialize() {
    print('🔄 Reinitializing API Client...');
    print('🔄 New Base URL: ${ApiEndpoints.baseUrl}');
    initialize();
  }
}

// Global instance
final apiClient = ApiClient();
