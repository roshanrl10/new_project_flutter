import 'package:dio/dio.dart';

Future<void> testApiEndpoints() async {
  final dio = Dio();
  const baseUrl = 'http://127.0.0.1:3000/api';
  const userId = '688339f4171a690ae2d5d852';

  print('🧪 Testing API endpoints...');

  try {
    // Test equipment rentals endpoint
    print('\n🔧 Testing equipment rentals endpoint...');
    final equipmentResponse = await dio.get(
      '$baseUrl/equipment/rentals',
      queryParameters: {'userId': userId},
    );
    print('✅ Equipment rentals status: ${equipmentResponse.statusCode}');
    print('✅ Equipment rentals data: ${equipmentResponse.data}');

    // Test agency bookings endpoint
    print('\n🏢 Testing agency bookings endpoint...');
    final agencyResponse = await dio.get(
      '$baseUrl/agencies/bookings',
      queryParameters: {'userId': userId},
    );
    print('✅ Agency bookings status: ${agencyResponse.statusCode}');
    print('✅ Agency bookings data: ${agencyResponse.data}');

    print('\n🎉 All API endpoints are working correctly!');
  } catch (e) {
    print('❌ Error testing API endpoints: $e');
  }
}

void main() {
  testApiEndpoints();
}
