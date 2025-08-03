import 'package:dio/dio.dart';

Future<void> testFlutterConnection() async {
  final dio = Dio();

  try {
    print('🧪 Testing Flutter app connection to backend...');

    // Test hotels endpoint
    final hotelsResponse = await dio.get('http://127.0.0.1:3000/api/hotels');
    print('✅ Hotels endpoint working: ${hotelsResponse.statusCode}');

    // Test user bookings endpoint
    final bookingsResponse = await dio.get(
      'http://127.0.0.1:3000/api/bookings',
      queryParameters: {'userId': '688e79727d3531f673be3d43'},
    );
    print('✅ User bookings endpoint working: ${bookingsResponse.statusCode}');
    print('📊 Bookings response: ${bookingsResponse.data}');
  } catch (e) {
    print('❌ Connection failed: $e');
  }
}
