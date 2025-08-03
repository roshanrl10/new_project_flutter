import 'package:dio/dio.dart';

Future<void> debugBookingCompleteFlow() async {
  final dio = Dio();
  const baseUrl = 'http://127.0.0.1:3000/api';
  const userId = '688339f4171a690ae2d5d852';

  print('🔍 COMPREHENSIVE BOOKING DEBUG TEST');
  print('🔗 Base URL: $baseUrl');
  print('👤 Test User ID: $userId');
  print('=' * 60);

  try {
    // STEP 1: Check current state
    print('\n📋 STEP 1: Checking current bookings state...');
    final initialResponse = await dio.get(
      '$baseUrl/bookings',
      queryParameters: {'userId': userId},
    );

    if (initialResponse.data['success'] == true) {
      final initialBookings = initialResponse.data['bookings'] ?? [];
      print('✅ Found ${initialBookings.length} existing bookings');

      for (int i = 0; i < initialBookings.length; i++) {
        final booking = initialBookings[i];
        print('📋 Booking ${i + 1}:');
        print('   ID: ${booking['_id']}');
        print('   Hotel: ${booking['hotel']?['name'] ?? 'Unknown'}');
        print('   Status: ${booking['status']}');
        print('   User: ${booking['user']}');
        print('   Check-in: ${booking['checkIn']}');
        print('   Check-out: ${booking['checkOut']}');
        print('   Guests: ${booking['guests']}');
        print('   ---');
      }
    }

    // STEP 2: Create a new booking
    print('\n➕ STEP 2: Creating a new booking...');
    final hotelsResponse = await dio.get('$baseUrl/hotels');

    if (hotelsResponse.data['success'] == true &&
        (hotelsResponse.data['hotels'] ?? []).isNotEmpty) {
      final firstHotel = hotelsResponse.data['hotels'][0];
      print('🏨 Using hotel: ${firstHotel['name']} (ID: ${firstHotel['_id']})');

      final bookingData = {
        'user': userId,
        'hotel': firstHotel['_id'],
        'checkIn': '2025-02-15',
        'checkOut': '2025-02-17',
        'guests': 2,
      };

      print('📝 Creating booking with data: $bookingData');
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
        print('✅ Check-in: ${newBooking['checkIn']}');
        print('✅ Check-out: ${newBooking['checkOut']}');
        print('✅ Guests: ${newBooking['guests']}');

        // STEP 3: Test Flutter's BookingModel.fromJson parsing
        print('\n🏗️ STEP 3: Testing Flutter BookingModel parsing...');
        try {
          // Simulate what Flutter's BookingModel.fromJson would do
          final hotelName =
              newBooking['hotel'] is Map<String, dynamic>
                  ? newBooking['hotel']['name'] ?? ''
                  : '';

          double totalPrice = 0.0;
          if (newBooking['hotel'] is Map<String, dynamic> &&
              newBooking['hotel']['price'] != null) {
            final hotelPrice = (newBooking['hotel']['price'] as num).toDouble();
            final checkIn = DateTime.parse(newBooking['checkIn']);
            final checkOut = DateTime.parse(newBooking['checkOut']);
            final days = checkOut.difference(checkIn).inDays;
            final guests = newBooking['guests'] ?? 1;
            totalPrice = hotelPrice * days * guests;
          }

          final parsedBooking = {
            'id': newBooking['_id'],
            'hotelId':
                newBooking['hotel'] is Map<String, dynamic>
                    ? newBooking['hotel']['_id'] ?? ''
                    : '',
            'userId': newBooking['user'],
            'checkInDate': DateTime.parse(newBooking['checkIn']),
            'checkOutDate': DateTime.parse(newBooking['checkOut']),
            'totalPrice': totalPrice,
            'status': newBooking['status'] ?? 'confirmed',
            'hotelName': hotelName,
            'userName': '',
          };

          print('✅ Flutter parsing successful!');
          print('✅ Parsed booking:');
          print('   ID: ${parsedBooking['id']}');
          print('   Hotel Name: ${parsedBooking['hotelName']}');
          print('   Status: ${parsedBooking['status']}');
          print('   Total Price: ${parsedBooking['totalPrice']}');
          print('   User ID: ${parsedBooking['userId']}');

          // Check if it would pass Flutter's filter
          if (parsedBooking['status'] == 'confirmed') {
            print('✅ Status is "confirmed" - will be visible in Flutter UI');
          } else {
            print(
              '❌ Status is not "confirmed" - will NOT be visible in Flutter UI',
            );
          }
        } catch (e) {
          print('❌ Error in Flutter parsing: $e');
        }

        // STEP 4: Check if booking appears in user bookings (what Flutter fetches)
        print(
          '\n📱 STEP 4: Checking if booking appears in user bookings (Flutter fetch)...',
        );
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
            print(
              '✅ This booking should appear in Flutter saved bookings page',
            );

            // Test Flutter parsing again with the fetched data
            try {
              final hotelName =
                  newBookingInList['hotel'] is Map<String, dynamic>
                      ? newBookingInList['hotel']['name'] ?? ''
                      : '';

              double totalPrice = 0.0;
              if (newBookingInList['hotel'] is Map<String, dynamic> &&
                  newBookingInList['hotel']['price'] != null) {
                final hotelPrice =
                    (newBookingInList['hotel']['price'] as num).toDouble();
                final checkIn = DateTime.parse(newBookingInList['checkIn']);
                final checkOut = DateTime.parse(newBookingInList['checkOut']);
                final days = checkOut.difference(checkIn).inDays;
                final guests = newBookingInList['guests'] ?? 1;
                totalPrice = hotelPrice * days * guests;
              }

              final parsedFromFetch = {
                'id': newBookingInList['_id'],
                'hotelId':
                    newBookingInList['hotel'] is Map<String, dynamic>
                        ? newBookingInList['hotel']['_id'] ?? ''
                        : '',
                'userId': newBookingInList['user'],
                'checkInDate': DateTime.parse(newBookingInList['checkIn']),
                'checkOutDate': DateTime.parse(newBookingInList['checkOut']),
                'totalPrice': totalPrice,
                'status': newBookingInList['status'] ?? 'confirmed',
                'hotelName': hotelName,
                'userName': '',
              };

              print('✅ Flutter parsing from fetch successful!');
              print('✅ Parsed booking from fetch:');
              print('   ID: ${parsedFromFetch['id']}');
              print('   Hotel Name: ${parsedFromFetch['hotelName']}');
              print('   Status: ${parsedFromFetch['status']}');
              print('   Total Price: ${parsedFromFetch['totalPrice']}');

              if (parsedFromFetch['status'] == 'confirmed') {
                print(
                  '✅ Status is "confirmed" - will be visible in Flutter UI',
                );
                print('✅ The booking should appear in saved bookings page!');
              } else {
                print(
                  '❌ Status is not "confirmed" - will NOT be visible in Flutter UI',
                );
                print('❌ This is why the booking is not appearing!');
              }
            } catch (e) {
              print('❌ Error in Flutter parsing from fetch: $e');
            }
          } else {
            print('❌ ERROR: New booking not found in user bookings');
            print(
              '❌ This means the booking was not properly associated with the user',
            );
          }
        } else {
          print('❌ ERROR: Failed to fetch user bookings');
          print('❌ Response: ${userBookingsResponse.data}');
        }

        // STEP 5: Check admin view
        print('\n🏢 STEP 5: Checking admin view...');
        final adminResponse = await dio.get('$baseUrl/bookings/admin/all');

        if (adminResponse.data['success'] == true) {
          final adminBookings = adminResponse.data['bookings'] ?? [];
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
        } else {
          print('❌ ERROR: Failed to fetch admin bookings');
          print('❌ Response: ${adminResponse.data}');
        }

        // STEP 6: Clean up
        print('\n🗑️ STEP 6: Cleaning up...');
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

    print('\n🎉 COMPREHENSIVE DEBUG TEST COMPLETED!');
    print('=' * 60);
    print('📋 SUMMARY:');
    print(
      '✅ This test helps identify exactly where the booking visibility issue occurs',
    );
    print('✅ It tests:');
    print('   1. Backend booking creation');
    print('   2. Flutter BookingModel parsing');
    print('   3. User bookings fetch (what Flutter uses)');
    print('   4. Admin view fetch');
    print('   5. Status filtering logic');
    print('✅ If the booking appears in user bookings but not in Flutter UI,');
    print('   the issue is in the Flutter app logic or state management');
  } catch (e) {
    print('❌ Error in comprehensive debug test: $e');
    if (e is DioException && e.response != null) {
      print('Response status: ${e.response!.statusCode}');
      print('Response data: ${e.response!.data}');
    }
  }
}

void main() {
  debugBookingCompleteFlow();
}
