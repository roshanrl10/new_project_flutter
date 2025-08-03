import 'package:dio/dio.dart';
import 'api_client.dart';

class ApiService {
  final Dio _dio = apiClient.dio;

  // GET request
  Future<Response> get(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await _dio.get(
        endpoint,
        queryParameters: queryParameters,
      );
      return response;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // POST request
  Future<Response> post(String endpoint, {dynamic data}) async {
    try {
      final response = await _dio.post(endpoint, data: data);
      return response;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // PUT request
  Future<Response> put(String endpoint, {dynamic data}) async {
    try {
      final response = await _dio.put(endpoint, data: data);
      return response;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // DELETE request
  Future<Response> delete(String endpoint) async {
    try {
      final response = await _dio.delete(endpoint);
      return response;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // Upload file
  Future<Response> uploadFile(String endpoint, FormData formData) async {
    try {
      final response = await _dio.post(endpoint, data: formData);
      return response;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Exception _handleError(DioException e) {
    print('🚨 API Error occurred:');
    print('🚨 Error type: ${e.type}');
    print('🚨 Error message: ${e.message}');
    print('🚨 Response status: ${e.response?.statusCode}');
    print('🚨 Response data: ${e.response?.data}');

    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return Exception('Connection timeout');
      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        // Safely extract message from response
        String message = 'Server error';
        try {
          final responseData = e.response?.data;
          if (responseData is Map<String, dynamic>) {
            message = responseData['message']?.toString() ?? 'Server error';
          } else if (responseData is String) {
            message = responseData;
          }
        } catch (error) {
          print('🚨 Error parsing response message: $error');
          message = 'Server error';
        }
        return Exception('HTTP $statusCode: $message');
      case DioExceptionType.cancel:
        return Exception('Request cancelled');
      default:
        return Exception('Network error: ${e.message}');
    }
  }
}
