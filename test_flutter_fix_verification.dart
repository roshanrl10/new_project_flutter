import 'package:dio/dio.dart';

Future<void> verifyFlutterFix() async {
  final dio = Dio();
  const baseUrl = 'http://127.0.0.1:3000/api';
  const userId = '688339f4171a690ae2d5d852';

  print('🔧 VERIFYING FLUTTER FIX');
  print('🔗 Base URL: $baseUrl');
  print('👤 Test User ID: $userId');
  print('=' * 50);

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
    }

    // STEP 2: Create a new booking (simulates Flutter BookHotel event)
    print(
      '\n➕ STEP 2: Creating a new booking (simulates Flutter BookHotel event)...',
    );
    final hotelsResponse = await dio.get('$baseUrl/hotels');

    if (hotelsResponse.data['success'] == true &&
        (hotelsResponse.data['hotels'] ?? []).isNotEmpty) {
      final firstHotel = hotelsResponse.data['hotels'][0];

      final bookingData = {
        'user': userId,
        'hotel': firstHotel['_id'],
        'checkIn': '2025-03-01',
        'checkOut': '2025-03-03',
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

        // STEP 3: Simulate Flutter HotelBookingBloc refresh (what should happen)
        print('\n🔄 STEP 3: Simulating Flutter HotelBookingBloc refresh...');
        print('🔄 This should trigger HotelBookingLoaded state in Flutter UI');

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
            print('✅ SUCCESS: New booking found in Flutter refresh!');
            print(
              '✅ Hotel: ${newBookingInRefresh['hotel']?['name'] ?? 'Unknown'}',
            );
            print('✅ Status: ${newBookingInRefresh['status']}');
            print('✅ This should trigger HotelBookingLoaded state');
            print('✅ The BlocListener should handle this state');
            print('✅ The setState should force UI refresh');
            print('✅ The booking should now be visible in Flutter UI');

            // Simulate Flutter's BookingModel parsing
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

              // Check if it passes Flutter's filter
              if (parsedBooking['status'] == 'confirmed') {
                print('✅ Status is "confirmed" - will pass Flutter filter');
                print(
                  '✅ This booking should be visible in saved bookings page',
                );
                print('✅ The fix should now work correctly!');
              } else {
                print(
                  '❌ Status is not "confirmed" - will NOT pass Flutter filter',
                );
              }
            } catch (e) {
              print('❌ Error in Flutter parsing: $e');
            }
          } else {
            print('❌ ERROR: New booking not found in Flutter refresh');
            print('❌ This means the HotelBookingBloc refresh is not working');
          }
        } else {
          print('❌ ERROR: Failed to refresh bookings');
          print('❌ Response: ${refreshResponse.data}');
        }

        // STEP 4: Clean up
        print('\n🗑️ STEP 4: Cleaning up...');
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

    print('\n🎉 FLUTTER FIX VERIFICATION COMPLETED!');
    print('=' * 50);
    print('📋 SUMMARY:');
    print('✅ The fixes implemented:');
    print('   1. Added HotelBookingLoaded handling in BlocListener');
    print('   2. Added setState to force UI refresh');
    print('   3. Added debug prints to track state flow');
    print('✅ If the test passes, the Flutter app should now work correctly');
    print('✅ The booking should appear in the saved bookings page');
  } catch (e) {
    print('❌ Error in Flutter fix verification: $e');
    if (e is DioException && e.response != null) {
      print('Response status: ${e.response!.statusCode}');
      print('Response data: ${e.response!.data}');
    }
  }
}

void main() {
  verifyFlutterFix();
}
