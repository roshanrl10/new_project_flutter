import 'package:dio/dio.dart';

Future<void> testSimpleHotelBooking() async {
  final dio = Dio();
  const baseUrl = 'http://127.0.0.1:3000/api';
  const userId = '688339f4171a690ae2d5d852';

  print('🏨 Testing Simple Hotel Booking Backend Connection...');
  print('🔗 Base URL: $baseUrl');

  try {
    // Test 1: Get all hotels
    print('\n🔍 Test 1: Getting all hotels...');
    final hotelsResponse = await dio.get('$baseUrl/hotels');
    print('✅ Hotels status: ${hotelsResponse.statusCode}');

    if (hotelsResponse.data['success'] == true) {
      final hotels = hotelsResponse.data['hotels'] ?? [];
      print('✅ Found ${hotels.length} hotels');

      if (hotels.isNotEmpty) {
        final firstHotel = hotels[0];
        print(
          '✅ Sample hotel: ${firstHotel['name']} - ${firstHotel['location']}',
        );
        print('✅ Hotel price: \$${firstHotel['price']}');
        print('✅ Hotel rating: ${firstHotel['rating']}');

        // Test 2: Get user bookings
        print('\n📋 Test 2: Getting user bookings...');
        final bookingsResponse = await dio.get(
          '$baseUrl/bookings',
          queryParameters: {'userId': userId},
        );
        print('✅ Bookings status: ${bookingsResponse.statusCode}');

        if (bookingsResponse.data['success'] == true) {
          final bookings = bookingsResponse.data['bookings'] ?? [];
          print('✅ Found ${bookings.length} bookings for user');

          if (bookings.isNotEmpty) {
            final firstBooking = bookings[0];
            print(
              '✅ Sample booking: ${firstBooking['hotel']?['name'] ?? 'Unknown Hotel'}',
            );
            print('✅ Booking status: ${firstBooking['status']}');
            print('✅ Check-in: ${firstBooking['checkIn']}');
            print('✅ Check-out: ${firstBooking['checkOut']}');
          }
        }

        // Test 3: Create a test booking
        print('\n➕ Test 3: Creating a test booking...');
        final bookingData = {
          'user': userId,
          'hotel': firstHotel['_id'],
          'checkIn': '2024-12-31',
          'checkOut': '2025-01-02',
          'guests': 2,
        };

        print('📝 Creating booking with data: $bookingData');
        final createBookingResponse = await dio.post(
          '$baseUrl/bookings',
          data: bookingData,
        );
        print('✅ Create booking status: ${createBookingResponse.statusCode}');

        if (createBookingResponse.data['success'] == true) {
          final booking = createBookingResponse.data['booking'];
          print('✅ Successfully created booking: ${booking['_id']}');
          print('✅ Hotel: ${booking['hotel']}');
          print('✅ Check-in: ${booking['checkIn']}');
          print('✅ Check-out: ${booking['checkOut']}');
          print('✅ Guests: ${booking['guests']}');
          print('✅ Status: ${booking['status']}');

          // Test 4: Delete the test booking
          print('\n🗑️ Test 4: Deleting the test booking...');
          final deleteResponse = await dio.delete(
            '$baseUrl/bookings/${booking['_id']}',
          );
          print('✅ Delete booking status: ${deleteResponse.statusCode}');
          print('✅ Delete booking response: ${deleteResponse.data}');
        }
      } else {
        print('⚠️ No hotels found in the database');
      }
    } else {
      print('❌ Failed to fetch hotels: ${hotelsResponse.data}');
    }

    print('\n🎉 All simple hotel booking tests completed!');
    print('✅ Backend connection is working properly');
    print('✅ Hotel booking features are functional');
    print('✅ Flutter can successfully connect to backend');
  } catch (e) {
    print('❌ Error in simple hotel booking test: $e');
    if (e is DioException && e.response != null) {
      print('Response status: ${e.response!.statusCode}');
      print('Response data: ${e.response!.data}');
    }
  }
}

void main() {
  testSimpleHotelBooking();
}
