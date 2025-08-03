import 'package:dio/dio.dart';

Future<void> simulateUserFlow() async {
  final dio = Dio();
  const baseUrl = 'http://127.0.0.1:3000/api';
  const userId = '688339f4171a690ae2d5d852';

  print('🎭 SIMULATING EXACT USER FLOW');
  print('🔗 Base URL: $baseUrl');
  print('👤 Test User ID: $userId');
  print('=' * 50);

  try {
    // STEP 1: User opens Flutter app and navigates to saved bookings page
    print(
      '\n📱 STEP 1: User opens Flutter app and navigates to saved bookings page',
    );
    print(
      '📱 This triggers _initializeBookings() -> _loadAllBookings() -> FetchUserBookings',
    );

    final initialBookingsResponse = await dio.get(
      '$baseUrl/bookings',
      queryParameters: {'userId': userId},
    );

    if (initialBookingsResponse.data['success'] == true) {
      final initialBookings = initialBookingsResponse.data['bookings'] ?? [];
      print('✅ Flutter app found ${initialBookings.length} initial bookings');

      for (int i = 0; i < initialBookings.length; i++) {
        final booking = initialBookings[i];
        print(
          '📋 Initial booking ${i + 1}: ${booking['hotel']?['name'] ?? 'Unknown'} (${booking['status']})',
        );
      }
    }

    // STEP 2: User navigates to hotel booking page and creates a booking
    print(
      '\n🏨 STEP 2: User navigates to hotel booking page and creates a booking',
    );
    print('🏨 This triggers BookHotel event in HotelBookingBloc');

    final hotelsResponse = await dio.get('$baseUrl/hotels');

    if (hotelsResponse.data['success'] == true &&
        (hotelsResponse.data['hotels'] ?? []).isNotEmpty) {
      final firstHotel = hotelsResponse.data['hotels'][0];

      final bookingData = {
        'user': userId,
        'hotel': firstHotel['_id'],
        'checkIn': '2025-02-25',
        'checkOut': '2025-02-27',
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

        // STEP 3: HotelBookingBloc refreshes bookings after successful booking
        print(
          '\n🔄 STEP 3: HotelBookingBloc refreshes bookings after successful booking',
        );
        print(
          '🔄 This is what happens in BookHotel event after emit(HotelBookingSuccess)',
        );

        final refreshResponse = await dio.get(
          '$baseUrl/bookings',
          queryParameters: {'userId': userId},
        );

        if (refreshResponse.data['success'] == true) {
          final refreshedBookings = refreshResponse.data['bookings'] ?? [];
          print(
            '✅ HotelBookingBloc found ${refreshedBookings.length} bookings after refresh',
          );

          // Find the newly created booking
          final newBookingInRefresh = refreshedBookings.firstWhere(
            (booking) => booking['_id'] == newBooking['_id'],
            orElse: () => null,
          );

          if (newBookingInRefresh != null) {
            print('✅ SUCCESS: New booking found in HotelBookingBloc refresh!');
            print(
              '✅ Hotel: ${newBookingInRefresh['hotel']?['name'] ?? 'Unknown'}',
            );
            print('✅ Status: ${newBookingInRefresh['status']}');
            print(
              '✅ This should trigger HotelBookingLoaded state in Flutter UI',
            );
          } else {
            print('❌ ERROR: New booking not found in HotelBookingBloc refresh');
          }
        }

        // STEP 4: User navigates back to saved bookings page
        print('\n📱 STEP 4: User navigates back to saved bookings page');
        print('📱 This triggers _loadAllBookings() -> FetchUserBookings again');

        final savedBookingsResponse = await dio.get(
          '$baseUrl/bookings',
          queryParameters: {'userId': userId},
        );

        if (savedBookingsResponse.data['success'] == true) {
          final savedBookings = savedBookingsResponse.data['bookings'] ?? [];
          print(
            '✅ Saved bookings page found ${savedBookings.length} total bookings',
          );

          // Filter for confirmed bookings (what Flutter does)
          final confirmedBookings =
              savedBookings
                  .where((booking) => booking['status'] == 'confirmed')
                  .toList();

          print('✅ Found ${confirmedBookings.length} confirmed bookings');

          final newBookingInSaved = confirmedBookings.firstWhere(
            (booking) => booking['_id'] == newBooking['_id'],
            orElse: () => null,
          );

          if (newBookingInSaved != null) {
            print('✅ SUCCESS: New booking found in saved bookings page!');
            print(
              '✅ Hotel: ${newBookingInSaved['hotel']?['name'] ?? 'Unknown'}',
            );
            print('✅ Status: ${newBookingInSaved['status']}');
            print('✅ This booking should be visible in the Flutter UI');
            print(
              '✅ If it\'s not visible, the issue is in Flutter state management',
            );
          } else {
            print('❌ ERROR: New booking not found in saved bookings page');
            print('❌ This means the booking is not being filtered correctly');
          }
        }

        // STEP 5: Clean up
        print('\n🗑️ STEP 5: Cleaning up...');
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

    print('\n🎉 USER FLOW SIMULATION COMPLETED!');
    print('=' * 50);
    print('📋 SUMMARY:');
    print('✅ This test simulates the exact user flow:');
    print('   1. User opens saved bookings page');
    print('   2. User creates a new booking');
    print('   3. HotelBookingBloc refreshes bookings');
    print('   4. User navigates back to saved bookings page');
    print('✅ If all steps pass but booking doesn\'t appear in Flutter UI,');
    print('   the issue is in Flutter state management or UI rendering');
  } catch (e) {
    print('❌ Error in user flow simulation: $e');
    if (e is DioException && e.response != null) {
      print('Response status: ${e.response!.statusCode}');
      print('Response data: ${e.response!.data}');
    }
  }
}

void main() {
  simulateUserFlow();
}
