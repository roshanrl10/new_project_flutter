import 'package:dio/dio.dart';

Future<void> testHotelBookingConnection() async {
  final dio = Dio();
  const baseUrl = 'http://127.0.0.1:3000/api';
  const userId = '688339f4171a690ae2d5d852';

  print('🏨 Testing Hotel Booking Backend Connection...');
  print('🔗 Base URL: $baseUrl');

  try {
    // Test 1: Check if backend is running
    print('\n🔍 Test 1: Checking if backend is running...');
    final response = await dio.get('$baseUrl/hotels');
    print('✅ Backend is running! Status: ${response.statusCode}');
    print('✅ Response: ${response.data}');

    // Test 2: Get all hotels
    print('\n🏨 Test 2: Testing get all hotels endpoint...');
    final hotelsResponse = await dio.get('$baseUrl/hotels');
    print('✅ Hotels status: ${hotelsResponse.statusCode}');
    print('✅ Hotels data: ${hotelsResponse.data}');

    if (hotelsResponse.data['success'] == true) {
      final hotels = hotelsResponse.data['hotels'] ?? [];
      print('✅ Found ${hotels.length} hotels');
      if (hotels.isNotEmpty) {
        print('✅ Sample hotel: ${hotels[0]}');
      }
    }

    // Test 3: Get user bookings
    print('\n📋 Test 3: Testing get user bookings endpoint...');
    final bookingsResponse = await dio.get(
      '$baseUrl/bookings',
      queryParameters: {'userId': userId},
    );
    print('✅ Bookings status: ${bookingsResponse.statusCode}');
    print('✅ Bookings data: ${bookingsResponse.data}');

    if (bookingsResponse.data['success'] == true) {
      final bookings = bookingsResponse.data['bookings'] ?? [];
      print('✅ Found ${bookings.length} bookings for user');
    }

    // Test 4: Create a test booking (if hotels exist)
    print('\n➕ Test 4: Testing create booking endpoint...');
    if (hotelsResponse.data['success'] == true &&
        (hotelsResponse.data['hotels'] ?? []).isNotEmpty) {
      final firstHotel = hotelsResponse.data['hotels'][0];
      final bookingData = {
        'user': userId,
        'hotel': firstHotel['_id'],
        'checkIn': '2024-12-25',
        'checkOut': '2024-12-27',
        'guests': 2,
      };

      print('📝 Creating booking with data: $bookingData');
      final createBookingResponse = await dio.post(
        '$baseUrl/bookings',
        data: bookingData,
      );
      print('✅ Create booking status: ${createBookingResponse.statusCode}');
      print('✅ Create booking response: ${createBookingResponse.data}');

      if (createBookingResponse.data['success'] == true) {
        final bookingId = createBookingResponse.data['booking']['_id'];
        print('✅ Created booking with ID: $bookingId');

        // Test 5: Delete the test booking
        print('\n🗑️ Test 5: Testing delete booking endpoint...');
        final deleteResponse = await dio.delete('$baseUrl/bookings/$bookingId');
        print('✅ Delete booking status: ${deleteResponse.statusCode}');
        print('✅ Delete booking response: ${deleteResponse.data}');
      }
    } else {
      print('⚠️ No hotels found, skipping booking creation test');
    }

    print('\n🎉 All hotel booking tests completed successfully!');
    print('✅ Flutter can connect to backend for hotel booking features');
  } catch (e) {
    print('❌ Error testing hotel booking connection: $e');
    if (e is DioException && e.response != null) {
      print('Response status: ${e.response!.statusCode}');
      print('Response data: ${e.response!.data}');
    }
  }
}

void main() {
  testHotelBookingConnection();
}
