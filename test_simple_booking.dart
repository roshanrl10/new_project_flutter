import 'package:dio/dio.dart';

void main() async {
  print('🧪 Testing simple booking creation...');

  final dio = Dio();

  try {
    // Test booking creation
    print('\n🧪 Creating a new booking...');
    final bookingData = {
      'hotel':
          '68834656c535f87c6e022ada', // Use the actual hotel ID from the GET response
      'user': '688339f4171a690ae2d5d852',
      'checkIn': '2024-12-28',
      'checkOut': '2024-12-30',
      'guests': 1,
    };

    final response = await dio.post(
      'http://127.0.0.1:3000/api/bookings',
      data: bookingData,
    );

    print('✅ Booking created successfully');
    print('✅ Booking ID: ${response.data['_id']}');
    print('✅ Status: ${response.data['status']}');
    print('✅ Hotel: ${response.data['hotel']?['name'] ?? 'Unknown'}');

    print('\n✅ Booking creation test completed');
    print('📱 The booking should now appear in Flutter saved bookings page');
  } catch (e) {
    print('❌ Error during booking creation: $e');
    if (e.toString().contains('404')) {
      print('❌ 404 error - check if the POST endpoint is correct');
    }
  }
}
