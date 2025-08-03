import 'package:dio/dio.dart';

Future<void> testFlutterStateRefresh() async {
  final dio = Dio();
  const baseUrl = 'http://127.0.0.1:3000/api';
  const userId = '688339f4171a690ae2d5d852';

  print('🔍 TESTING FLUTTER STATE REFRESH FLOW');
  print('🔗 Base URL: $baseUrl');
  print('👤 Test User ID: $userId');
  print('=' * 50);

  try {
    // STEP 1: Simulate Flutter app startup - fetch initial bookings
    print('\n📱 STEP 1: Flutter app starts - fetching initial bookings...');
    final initialResponse = await dio.get(
      '$baseUrl/bookings',
      queryParameters: {'userId': userId},
    );

    if (initialResponse.data['success'] == true) {
      final initialBookings = initialResponse.data['bookings'] ?? [];
      print('✅ Flutter found ${initialBookings.length} initial bookings');

      for (int i = 0; i < initialBookings.length; i++) {
        final booking = initialBookings[i];
        print(
          '📋 Initial booking ${i + 1}: ${booking['hotel']?['name'] ?? 'Unknown'} (${booking['status']})',
        );
      }
    }

    // STEP 2: Simulate user creating a new booking
    print('\n➕ STEP 2: User creates a new booking...');
    final hotelsResponse = await dio.get('$baseUrl/hotels');

    if (hotelsResponse.data['success'] == true &&
        (hotelsResponse.data['hotels'] ?? []).isNotEmpty) {
      final firstHotel = hotelsResponse.data['hotels'][0];

      final bookingData = {
        'user': userId,
        'hotel': firstHotel['_id'],
        'checkIn': '2025-02-20',
        'checkOut': '2025-02-22',
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

        // STEP 3: Simulate Flutter HotelBookingBloc refresh after booking
        print(
          '\n🔄 STEP 3: Flutter HotelBookingBloc refreshes after booking...',
        );
        print(
          '🔄 This is what happens in BookHotel event after successful booking',
        );

        // Simulate the exact flow in HotelBookingBloc
        final refreshResponse = await dio.get(
          '$baseUrl/bookings',
          queryParameters: {'userId': userId},
        );

        if (refreshResponse.data['success'] == true) {
          final refreshedBookings = refreshResponse.data['bookings'] ?? [];
          print(
            '✅ Flutter found ${refreshedBookings.length} bookings after refresh',
          );

          // Find the newly created booking
          final newBookingInRefresh = refreshedBookings.firstWhere(
            (booking) => booking['_id'] == newBooking['_id'],
            orElse: () => null,
          );

          if (newBookingInRefresh != null) {
            print('✅ SUCCESS: New booking found in refresh!');
            print(
              '✅ Hotel: ${newBookingInRefresh['hotel']?['name'] ?? 'Unknown'}',
            );
            print('✅ Status: ${newBookingInRefresh['status']}');
            print('✅ This booking should appear in Flutter UI');

            // Simulate Flutter's BookingModel.fromJson parsing
            try {
              final hotelName =
                  newBookingInRefresh['hotel'] is Map<String, dynamic>
                      ? newBookingInRefresh['hotel']['name'] ?? ''
                      : '';

              double totalPrice = 0.0;
              if (newBookingInRefresh['hotel'] is Map<String, dynamic> &&
                  newBookingInRefresh['hotel']['price'] != null) {
                final hotelPrice =
                    (newBookingInRefresh['hotel']['price'] as num).toDouble();
                final checkIn = DateTime.parse(newBookingInRefresh['checkIn']);
                final checkOut = DateTime.parse(
                  newBookingInRefresh['checkOut'],
                );
                final days = checkOut.difference(checkIn).inDays;
                final guests = newBookingInRefresh['guests'] ?? 1;
                totalPrice = hotelPrice * days * guests;
              }

              final parsedBooking = {
                'id': newBookingInRefresh['_id'],
                'hotelId':
                    newBookingInRefresh['hotel'] is Map<String, dynamic>
                        ? newBookingInRefresh['hotel']['_id'] ?? ''
                        : '',
                'userId': newBookingInRefresh['user'],
                'checkInDate': DateTime.parse(newBookingInRefresh['checkIn']),
                'checkOutDate': DateTime.parse(newBookingInRefresh['checkOut']),
                'totalPrice': totalPrice,
                'status': newBookingInRefresh['status'] ?? 'confirmed',
                'hotelName': hotelName,
                'userName': '',
              };

              print('✅ Flutter BookingModel parsing successful!');
              print('✅ Parsed booking:');
              print('   ID: ${parsedBooking['id']}');
              print('   Hotel Name: ${parsedBooking['hotelName']}');
              print('   Status: ${parsedBooking['status']}');
              print('   Total Price: ${parsedBooking['totalPrice']}');

              // Check if it passes Flutter's filter in SavedBookingsPage
              if (parsedBooking['status'] == 'confirmed') {
                print('✅ Status is "confirmed" - will pass Flutter filter');
                print(
                  '✅ This booking should be visible in saved bookings page',
                );
                print(
                  '✅ The issue might be in Flutter state management or UI refresh',
                );
              } else {
                print(
                  '❌ Status is not "confirmed" - will NOT pass Flutter filter',
                );
                print('❌ This is why the booking is not appearing');
              }
            } catch (e) {
              print('❌ Error in Flutter parsing: $e');
            }
          } else {
            print('❌ ERROR: New booking not found in refresh');
            print('❌ This means the HotelBookingBloc refresh is not working');
          }
        } else {
          print('❌ ERROR: Failed to refresh bookings');
          print('❌ Response: ${refreshResponse.data}');
        }

        // STEP 4: Simulate user navigating to saved bookings page
        print('\n📱 STEP 4: User navigates to saved bookings page...');
        print('📱 This triggers _loadAllBookings() in SavedBookingsPage');

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
            print('✅ This booking should be visible in the UI');
            print(
              '✅ If it\'s not visible, the issue is in Flutter UI rendering',
            );
          } else {
            print('❌ ERROR: New booking not found in saved bookings page');
            print('❌ This means the booking is not being filtered correctly');
          }
        } else {
          print('❌ ERROR: Failed to fetch saved bookings');
          print('❌ Response: ${savedBookingsResponse.data}');
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

    print('\n🎉 FLUTTER STATE REFRESH TEST COMPLETED!');
    print('=' * 50);
    print('📋 SUMMARY:');
    print('✅ This test simulates the exact Flutter app flow:');
    print('   1. App starts and loads initial bookings');
    print('   2. User creates a new booking');
    print('   3. HotelBookingBloc refreshes after booking');
    print('   4. User navigates to saved bookings page');
    print('   5. SavedBookingsPage loads and filters bookings');
    print('✅ If all steps pass but booking doesn\'t appear in UI,');
    print('   the issue is in Flutter state management or UI rendering');
  } catch (e) {
    print('❌ Error in Flutter state refresh test: $e');
    if (e is DioException && e.response != null) {
      print('Response status: ${e.response!.statusCode}');
      print('Response data: ${e.response!.data}');
    }
  }
}

void main() {
  testFlutterStateRefresh();
}
