import 'package:new_project_flutter/features/agency/domain/entity/agency_booking_entity.dart';

void main() {
  print('🏢 Testing Agency Booking Flow...');

  // Test 1: Create agency booking data
  print('\n📋 Test 1: Creating Agency Booking Data');

  final bookingData = {
    'user': '688339f4171a690ae2d5d852',
    'agency': 'agency-123',
    'startDate': DateTime.now().toIso8601String(),
    'endDate': DateTime.now().add(const Duration(days: 7)).toIso8601String(),
    'numberOfPeople': 2,
    'totalPrice': 700.0,
    'status': 'confirmed',
    'specialRequests': 'Booking from Flutter app',
  };

  print('📤 Booking data:');
  print('  - Agency ID: ${bookingData['agency']}');
  print('  - Status: ${bookingData['status']}');
  print('  - Total Price: ${bookingData['totalPrice']}');
  print('  - Number of People: ${bookingData['numberOfPeople']}');

  // Test 2: Create AgencyBooking entity
  print('\n📋 Test 2: Creating AgencyBooking Entity');
  try {
    final booking = AgencyBooking(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      agencyId: (bookingData['agency'] as String?) ?? '',
      userId: (bookingData['user'] as String?) ?? '',
      startDate: DateTime.parse(bookingData['startDate'] as String),
      endDate: DateTime.parse(bookingData['endDate'] as String),
      numberOfPeople: (bookingData['numberOfPeople'] as int?) ?? 1,
      totalPrice: (bookingData['totalPrice'] as num).toDouble(),
      status: (bookingData['status'] as String?) ?? 'confirmed',
      agencyName: 'Trekking Agency',
      userName: 'Current User',
      specialRequests: (bookingData['specialRequests'] as String?) ?? '',
    );

    print('✅ AgencyBooking created successfully!');
    print('  - ID: ${booking.id}');
    print('  - Agency Name: ${booking.agencyName}');
    print('  - Status: ${booking.status}');
    print('  - Total Price: ${booking.totalPrice}');
    print('  - Number of People: ${booking.numberOfPeople}');

    // Test 3: Simulate adding to local bookings list
    print('\n📋 Test 3: Simulate adding to local bookings list');
    List<AgencyBooking> localBookings = [];
    localBookings.add(booking);
    print('✅ Added booking to local bookings list');
    print('🏢 Total local bookings: ${localBookings.length}');

    // Test 4: Simulate AgencyBookingLoaded state
    print('\n📋 Test 4: Simulate AgencyBookingLoaded state');
    print('🏢 AgencyBookingLoaded state would contain:');
    print('  - ${localBookings.length} bookings');
    for (int i = 0; i < localBookings.length; i++) {
      final b = localBookings[i];
      print('  - Booking $i: ${b.agencyName} (${b.status})');
    }

    // Test 5: Verify data for UI display
    print('\n📋 Test 5: Verify data for UI display');
    if (localBookings.isNotEmpty) {
      final bookingForDisplay = localBookings[0];
      print('🏢 Data for UI card:');
      print('  - Agency Name: ${bookingForDisplay.agencyName}');
      print('  - Status: ${bookingForDisplay.status}');
      print('  - Total Price: ${bookingForDisplay.totalPrice}');
      print('  - Number of People: ${bookingForDisplay.numberOfPeople}');
      print('  - Start Date: ${bookingForDisplay.startDate}');
      print('  - End Date: ${bookingForDisplay.endDate}');

      // Check if any field is empty or null
      if (bookingForDisplay.agencyName.isEmpty) {
        print('❌ Agency name is empty!');
      }
      if (bookingForDisplay.status.isEmpty) {
        print('❌ Status is empty!');
      }
      if (bookingForDisplay.totalPrice <= 0) {
        print('❌ Total price is invalid!');
      }
      if (bookingForDisplay.numberOfPeople <= 0) {
        print('❌ Number of people is invalid!');
      }
    }
  } catch (e) {
    print('❌ Error in agency booking flow: $e');
  }

  print('\n🎉 Agency booking flow test completed!');
  print('💡 If the test passes, the agency booking should work in Flutter');
}
