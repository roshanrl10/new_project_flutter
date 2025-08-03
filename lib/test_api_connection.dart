import 'package:dio/dio.dart';

Future<void> testApiConnection() async {
  final dio = Dio();

  try {
    print('🧪 Testing API connection from Flutter...');

    // Test hotels endpoint
    final response = await dio.get('http://127.0.0.1:3000/api/hotels');
    print('✅ API connection successful!');
    print('📊 Status: ${response.statusCode}');
    print('📊 Data: ${response.data}');
  } catch (e) {
    print('❌ API connection failed: $e');
  }
}
