import 'package:dio/dio.dart';

Future<void> testBackendConnection() async {
  final dio = Dio();
  const baseUrl = 'http://127.0.0.1:3000/api';
  const userId = '688339f4171a690ae2d5d852';

  print('🧪 Testing backend connection...');

  try {
    // Test 1: Check if backend is running
    print('\n🔍 Test 1: Checking if backend is running...');
    final response = await dio.get('$baseUrl/equipment');
    print('✅ Backend is running! Status: ${response.statusCode}');
    print('✅ Equipment count: ${response.data.length}');

    // Test 2: Test equipment rentals endpoint
    print('\n🔧 Test 2: Testing equipment rentals endpoint...');
    final equipmentRentalsResponse = await dio.get(
      '$baseUrl/equipment/rentals',
      queryParameters: {'userId': userId},
    );
    print('✅ Equipment rentals status: ${equipmentRentalsResponse.statusCode}');
    print('✅ Equipment rentals data: ${equipmentRentalsResponse.data}');

    // Test 3: Test agency bookings endpoint
    print('\n🏢 Test 3: Testing agency bookings endpoint...');
    final agencyBookingsResponse = await dio.get(
      '$baseUrl/agencies/bookings',
      queryParameters: {'userId': userId},
    );
    print('✅ Agency bookings status: ${agencyBookingsResponse.statusCode}');
    print('✅ Agency bookings data: ${agencyBookingsResponse.data}');

    print('\n🎉 All backend tests completed successfully!');
  } catch (e) {
    print('❌ Error testing backend: $e');
    if (e is DioException && e.response != null) {
      print('Response status: ${e.response!.statusCode}');
      print('Response data: ${e.response!.data}');
    }
  }
}

void main() {
  testBackendConnection();
}
