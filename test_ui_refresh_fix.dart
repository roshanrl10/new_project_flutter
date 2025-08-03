import 'package:dio/dio.dart';

void main() async {
  print('🧪 Testing UI refresh fix...');

  final dio = Dio();

  try {
    // Test 1: Check current bookings
    print('\n🧪 Test 1: Checking current bookings...');
    final response1 = await dio.get(
      'http://127.0.0.1:3000/api/bookings',
      queryParameters: {'userId': '688339f4171a690ae2d5d852'},
    );

    print('✅ Current bookings: ${response1.data['bookings']?.length ?? 0}');
    final bookings = response1.data['bookings'] ?? [];
    for (var booking in bookings) {
      print(
        '  - ${booking['hotel']?['name'] ?? 'Unknown'} (${booking['status']})',
      );
    }

    // Test 2: Create a new booking
    print('\n🧪 Test 2: Creating a new booking...');
    final bookingData = {
      'hotel': '688339f4171a690ae2d5d852',
      'user': '688339f4171a690ae2d5d852',
      'checkIn': '2024-12-28',
      'checkOut': '2024-12-30',
      'guests': 1,
    };

    final response2 = await dio.post(
      'http://127.0.0.1:3000/api/bookings',
      data: bookingData,
    );

    print('✅ Booking created: ${response2.data['_id']}');
    print('✅ Status: ${response2.data['status']}');

    // Test 3: Check bookings again
    print('\n🧪 Test 3: Checking bookings after creation...');
    final response3 = await dio.get(
      'http://127.0.0.1:3000/api/bookings',
      queryParameters: {'userId': '688339f4171a690ae2d5d852'},
    );

    print('✅ Updated bookings: ${response3.data['bookings']?.length ?? 0}');
    final updatedBookings = response3.data['bookings'] ?? [];
    for (var booking in updatedBookings) {
      print(
        '  - ${booking['hotel']?['name'] ?? 'Unknown'} (${booking['status']})',
      );
    }

    // Test 4: Verify the new booking is confirmed
    final newBooking = updatedBookings.firstWhere(
      (booking) => booking['_id'] == response2.data['_id'],
      orElse: () => null,
    );

    if (newBooking != null) {
      print('✅ New booking found in list');
      print('✅ Status: ${newBooking['status']}');
      print('✅ Should appear in Flutter UI as confirmed booking');
    } else {
      print('❌ New booking not found in list');
    }

    print('\n✅ UI refresh fix test completed');
    print('📱 Now test in Flutter app:');
    print('   1. Go to hotel booking page');
    print('   2. Make a booking');
    print('   3. Navigate to saved bookings page');
    print('   4. Check if the new booking appears');
  } catch (e) {
    print('❌ Error during UI refresh test: $e');
  }
}
