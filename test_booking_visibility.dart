import 'package:dio/dio.dart';

Future<void> testBookingVisibility() async {
  final dio = Dio();
  const baseUrl = 'http://127.0.0.1:3000/api';
  const userId = '688339f4171a690ae2d5d852';

  print('🔍 Testing Booking Visibility Issue...');
  print('🔗 Base URL: $baseUrl');
  print('👤 Test User ID: $userId');

  try {
    // Step 1: Check current bookings
    print('\n📋 Step 1: Checking current user bookings...');
    final currentBookingsResponse = await dio.get(
      '$baseUrl/bookings',
      queryParameters: {'userId': userId},
    );

    if (currentBookingsResponse.data['success'] == true) {
      final currentBookings = currentBookingsResponse.data['bookings'] ?? [];
      print('✅ Found ${currentBookings.length} current bookings');

      for (int i = 0; i < currentBookings.length; i++) {
        final booking = currentBookings[i];
        print('📋 Booking ${i + 1}:');
        print('   ID: ${booking['_id']}');
        print('   Hotel: ${booking['hotel']?['name'] ?? 'Unknown'}');
        print('   Status: ${booking['status']}');
        print('   Check-in: ${booking['checkIn']}');
        print('   Check-out: ${booking['checkOut']}');
        print('   User: ${booking['user']}');
        print('   ---');
      }
    }

    // Step 2: Create a new booking
    print('\n➕ Step 2: Creating a new booking...');
    final hotelsResponse = await dio.get('$baseUrl/hotels');

    if (hotelsResponse.data['success'] == true &&
        (hotelsResponse.data['hotels'] ?? []).isNotEmpty) {
      final firstHotel = hotelsResponse.data['hotels'][0];

      final bookingData = {
        'user': userId,
        'hotel': firstHotel['_id'],
        'checkIn': '2025-02-01',
        'checkOut': '2025-02-03',
        'guests': 2,
      };

      print('📝 Creating booking for: ${firstHotel['name']}');
      final createResponse = await dio.post(
        '$baseUrl/bookings',
        data: bookingData,
      );

      if (createResponse.data['success'] == true) {
        final newBooking = createResponse.data['booking'];
        print('✅ Booking created successfully!');
        print('✅ Booking ID: ${newBooking['_id']}');
        print('✅ Status: ${newBooking['status']}');
        print('✅ Hotel: ${newBooking['hotel']}');
        print('✅ User: ${newBooking['user']}');

        // Step 3: Immediately check if booking appears in user bookings
        print('\n📋 Step 3: Checking if booking appears in user bookings...');
        await Future.delayed(Duration(seconds: 1));

        final userBookingsResponse = await dio.get(
          '$baseUrl/bookings',
          queryParameters: {'userId': userId},
        );

        if (userBookingsResponse.data['success'] == true) {
          final userBookings = userBookingsResponse.data['bookings'] ?? [];
          print('✅ Found ${userBookings.length} total user bookings');

          // Find the newly created booking
          final newBookingInList = userBookings.firstWhere(
            (booking) => booking['_id'] == newBooking['_id'],
            orElse: () => null,
          );

          if (newBookingInList != null) {
            print('✅ SUCCESS: New booking found in user bookings!');
            print(
              '✅ Hotel: ${newBookingInList['hotel']?['name'] ?? 'Unknown'}',
            );
            print('✅ Status: ${newBookingInList['status']}');
            print('✅ This should appear in Flutter saved bookings page');

            // Check if it would pass the Flutter filter
            if (newBookingInList['status'] == 'confirmed') {
              print(
                '✅ Status is "confirmed" - will appear in Flutter saved bookings',
              );
            } else {
              print(
                '❌ Status is not "confirmed" - will NOT appear in Flutter saved bookings',
              );
              print(
                '❌ Expected: confirmed, Got: ${newBookingInList['status']}',
              );
            }
          } else {
            print('❌ ERROR: New booking not found in user bookings');
            print(
              '❌ This means the booking was not properly associated with the user',
            );
          }
        }

        // Step 4: Check if the booking appears in all bookings (admin view)
        print('\n🏢 Step 4: Checking if booking appears in admin view...');
        final adminBookingsResponse = await dio.get(
          '$baseUrl/bookings/admin/all',
        );

        if (adminBookingsResponse.data['success'] == true) {
          final adminBookings = adminBookingsResponse.data['bookings'] ?? [];
          print('✅ Found ${adminBookings.length} total bookings in admin view');

          final newBookingInAdmin = adminBookings.firstWhere(
            (booking) => booking['_id'] == newBooking['_id'],
            orElse: () => null,
          );

          if (newBookingInAdmin != null) {
            print('✅ SUCCESS: New booking found in admin view!');
            print(
              '✅ Hotel: ${newBookingInAdmin['hotel']?['name'] ?? 'Unknown'}',
            );
            print('✅ Status: ${newBookingInAdmin['status']}');
            print('✅ User: ${newBookingInAdmin['user']}');
          } else {
            print('❌ ERROR: New booking not found in admin view');
          }
        }

        // Step 5: Clean up - delete the test booking
        print('\n🗑️ Step 5: Cleaning up...');
        final deleteResponse = await dio.delete(
          '$baseUrl/bookings/${newBooking['_id']}',
        );

        if (deleteResponse.data['success'] == true) {
          print('✅ Successfully deleted test booking');
        } else {
          print('❌ Failed to delete test booking');
        }
      } else {
        print('❌ ERROR: Failed to create booking: ${createResponse.data}');
      }
    } else {
      print('❌ ERROR: No hotels available for booking test');
    }

    print('\n🎉 Booking visibility test completed!');
    print(
      '✅ This test helps identify why bookings might not appear in Flutter saved bookings page',
    );
  } catch (e) {
    print('❌ Error in booking visibility test: $e');
    if (e is DioException && e.response != null) {
      print('Response status: ${e.response!.statusCode}');
      print('Response data: ${e.response!.data}');
    }
  }
}

void main() {
  testBookingVisibility();
}
