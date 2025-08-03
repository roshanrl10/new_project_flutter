import 'package:dio/dio.dart';

Future<void> testSavedBookings() async {
  final dio = Dio();

  try {
    print('🧪 Testing saved bookings from Flutter...');

    // Test user ID (same as used in the app)
    const userId = '688339f4171a690ae2d5d852';

    print('👤 Testing bookings for user: $userId');

    // Test fetching user bookings
    final response = await dio.get(
      'http://127.0.0.1:3000/api/bookings',
      queryParameters: {'userId': userId},
    );

    print('✅ Response status: ${response.statusCode}');
    print('📊 Response data: ${response.data}');

    if (response.data != null && response.data['bookings'] != null) {
      final bookings = response.data['bookings'] as List;
      print('📋 Found ${bookings.length} bookings:');

      for (int i = 0; i < bookings.length; i++) {
        final booking = bookings[i];
        print('  ${i + 1}. Hotel: ${booking['hotel']?['name'] ?? 'Unknown'}');
        print('     Status: ${booking['status']}');
        print('     Check-in: ${booking['checkIn']}');
        print('     Check-out: ${booking['checkOut']}');
        print('     Guests: ${booking['guests'] ?? 1}');
        print('');
      }
    } else {
      print('⚠️ No bookings found or invalid response format');
    }

    print('✅ Saved bookings test completed successfully!');
  } catch (e) {
    print('❌ Test failed: $e');
  }
}

void main() {
  testSavedBookings();
}
