import 'package:dio/dio.dart';

Future<void> testFlutterBookingFlow() async {
  final dio = Dio();
  const baseUrl = 'http://127.0.0.1:3000/api';
  const userId = '688339f4171a690ae2d5d852';

  print('📱 Testing Complete Flutter Booking Flow...');
  print('🔗 Base URL: $baseUrl');
  print('👤 Test User ID: $userId');

  try {
    // Step 1: Simulate user opening Flutter app and checking saved bookings
    print('\n📱 Step 1: User opens Flutter app and checks saved bookings...');
    final initialBookingsResponse = await dio.get(
      '$baseUrl/bookings',
      queryParameters: {'userId': userId},
    );

    if (initialBookingsResponse.data['success'] == true) {
      final initialBookings = initialBookingsResponse.data['bookings'] ?? [];
      print(
        '✅ User sees ${initialBookings.length} existing bookings in saved bookings page',
      );

      if (initialBookings.isNotEmpty) {
        print('✅ Existing bookings:');
        for (final booking in initialBookings) {
          print(
            '   - ${booking['hotel']?['name'] ?? 'Unknown'} (${booking['status']})',
          );
        }
      }
    }

    // Step 2: Simulate user browsing hotels
    print('\n🏨 Step 2: User browses hotels...');
    final hotelsResponse = await dio.get('$baseUrl/hotels');

    if (hotelsResponse.data['success'] == true) {
      final hotels = hotelsResponse.data['hotels'] ?? [];
      print('✅ User sees ${hotels.length} available hotels');

      if (hotels.isNotEmpty) {
        final selectedHotel = hotels[0];
        print('✅ User selects hotel: ${selectedHotel['name']}');

        // Step 3: Simulate user creating a booking
        print('\n➕ Step 3: User creates a booking...');
        final bookingData = {
          'user': userId,
          'hotel': selectedHotel['_id'],
          'checkIn': '2025-02-05',
          'checkOut': '2025-02-07',
          'guests': 2,
        };

        print('📝 Creating booking for: ${selectedHotel['name']}');
        final createResponse = await dio.post(
          '$baseUrl/bookings',
          data: bookingData,
        );

        if (createResponse.data['success'] == true) {
          final newBooking = createResponse.data['booking'];
          print('✅ SUCCESS: Booking created successfully!');
          print('✅ Booking ID: ${newBooking['_id']}');
          print('✅ Status: ${newBooking['status']}');
          print('✅ Hotel: ${selectedHotel['name']}');

          // Step 4: Simulate user navigating to saved bookings page
          print('\n📱 Step 4: User navigates to saved bookings page...');
          await Future.delayed(
            Duration(seconds: 2),
          ); // Simulate navigation time

          final savedBookingsResponse = await dio.get(
            '$baseUrl/bookings',
            queryParameters: {'userId': userId},
          );

          if (savedBookingsResponse.data['success'] == true) {
            final savedBookings = savedBookingsResponse.data['bookings'] ?? [];
            print(
              '✅ User sees ${savedBookings.length} total bookings in saved bookings page',
            );

            // Find the newly created booking
            final newBookingInSaved = savedBookings.firstWhere(
              (booking) => booking['_id'] == newBooking['_id'],
              orElse: () => null,
            );

            if (newBookingInSaved != null) {
              print('✅ SUCCESS: New booking appears in saved bookings page!');
              print(
                '✅ Hotel: ${newBookingInSaved['hotel']?['name'] ?? 'Unknown'}',
              );
              print('✅ Status: ${newBookingInSaved['status']}');
              print('✅ Check-in: ${newBookingInSaved['checkIn']}');
              print('✅ Check-out: ${newBookingInSaved['checkOut']}');
              print('✅ Guests: ${newBookingInSaved['guests']}');

              // Check if it would be visible in Flutter UI
              if (newBookingInSaved['status'] == 'confirmed') {
                print(
                  '✅ Status is "confirmed" - will be visible in Flutter saved bookings page',
                );
                print(
                  '✅ The booking should appear in the Flutter app saved bookings page',
                );
              } else {
                print(
                  '❌ Status is not "confirmed" - will NOT be visible in Flutter saved bookings page',
                );
                print(
                  '❌ Expected: confirmed, Got: ${newBookingInSaved['status']}',
                );
              }
            } else {
              print(
                '❌ ERROR: New booking does NOT appear in saved bookings page',
              );
              print(
                '❌ This indicates a problem with the booking association or page refresh',
              );
            }
          }

          // Step 5: Clean up
          print('\n🗑️ Step 5: Cleaning up test booking...');
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
    } else {
      print('❌ ERROR: Failed to fetch hotels: ${hotelsResponse.data}');
    }

    print('\n🎉 Flutter booking flow test completed!');
    print('✅ This test simulates the complete user journey:');
    print('   1. User opens Flutter app');
    print('   2. User browses hotels');
    print('   3. User creates a booking');
    print('   4. User navigates to saved bookings page');
    print('   5. User should see the new booking');
  } catch (e) {
    print('❌ Error in Flutter booking flow test: $e');
    if (e is DioException && e.response != null) {
      print('Response status: ${e.response!.statusCode}');
      print('Response data: ${e.response!.data}');
    }
  }
}

void main() {
  testFlutterBookingFlow();
}
