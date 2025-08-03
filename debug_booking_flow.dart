import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_project_flutter/features/hotelBooking/presentation/view_model/hotel_booking_bloc.dart';
import 'package:new_project_flutter/features/hotelBooking/presentation/view_model/hotel_booking_state.dart';
import 'package:new_project_flutter/features/hotelBooking/presentation/view_model/hotel_booking_event.dart';
import 'package:new_project_flutter/features/hotelBooking/domain/entity/booking_entity.dart';

void main() {
  print('🔍 Debugging Booking Flow...');

  // Test data that should work
  final testBookingData = {
    'user': 'test-user-123',
    'hotel': 'hotel-456',
    'hotelName': 'Test Hotel',
    'checkIn': DateTime.now().add(const Duration(days: 1)).toIso8601String(),
    'checkOut': DateTime.now().add(const Duration(days: 3)).toIso8601String(),
    'guests': 2,
    'totalPrice': 299.99,
    'status': 'confirmed',
  };

  print('📋 Test Booking Data:');
  print('  - User ID: ${testBookingData['user']}');
  print('  - Hotel ID: ${testBookingData['hotel']}');
  print('  - Hotel Name: ${testBookingData['hotelName']}');
  print('  - Check-in: ${testBookingData['checkIn']}');
  print('  - Check-out: ${testBookingData['checkOut']}');
  print('  - Guests: ${testBookingData['guests']}');
  print('  - Total Price: \$${testBookingData['totalPrice']}');
  print('  - Status: ${testBookingData['status']}');

  print('\n✅ Data format is correct!');
  print('\n💡 Next Steps:');
  print('1. Open your Flutter app');
  print('2. Go to hotel booking page');
  print('3. Create a booking');
  print('4. Check console for debug messages');
  print('5. Navigate to saved bookings page');
  print('6. Tell me what you see in the console');

  print('\n🔍 Common Issues to Check:');
  print('- Is the HotelBookingBloc properly initialized?');
  print('- Are the debug prints showing in console?');
  print('- Is the saved bookings page calling _loadLocalBookings()?');
  print('- Are the BlocBuilder widgets rebuilding?');
}
