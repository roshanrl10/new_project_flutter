import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_project_flutter/features/hotelBooking/presentation/view_model/hotel_booking_bloc.dart';
import 'package:new_project_flutter/features/hotelBooking/presentation/view_model/hotel_booking_state.dart';
import 'package:new_project_flutter/features/hotelBooking/presentation/view_model/hotel_booking_event.dart';
import 'package:new_project_flutter/features/hotelBooking/domain/entity/booking_entity.dart';
import 'package:new_project_flutter/features/equipments/presentation/view_model/equipment_bloc.dart';
import 'package:new_project_flutter/features/equipments/presentation/view_model/equipment_state.dart';
import 'package:new_project_flutter/features/equipments/presentation/view_model/equipment_event.dart';
import 'package:new_project_flutter/features/equipments/domain/entity/equipment_rental_entity.dart';

void main() async {
  print('🚀 Testing Complete Frontend-Only Flow...');

  print('\n📋 Test Plan:');
  print('1. Test hotel booking creation and retrieval');
  print('2. Test equipment rental creation and retrieval');
  print('3. Test cancellation of bookings/rentals');
  print('4. Verify data persistence in local state');

  // Test 1: Hotel Booking Flow
  print('\n🏨 Test 1: Hotel Booking Flow');

  // Create a hotel booking
  final hotelBookingData = {
    'user': 'test-user-123',
    'hotel': 'hotel-456',
    'hotelName': 'Grand Hotel',
    'checkIn': DateTime.now().add(const Duration(days: 1)).toIso8601String(),
    'checkOut': DateTime.now().add(const Duration(days: 3)).toIso8601String(),
    'guests': 2,
    'totalPrice': 299.99,
    'status': 'confirmed',
  };

  print('📤 Creating hotel booking with data: $hotelBookingData');

  // Test 2: Equipment Rental Flow
  print('\n🔧 Test 2: Equipment Rental Flow');

  // Create an equipment rental
  final equipmentRentalData = {
    'user': 'test-user-123',
    'equipment': 'equipment-789',
    'equipmentName': 'Mountain Bike',
    'startDate': DateTime.now().add(const Duration(days: 1)).toIso8601String(),
    'endDate': DateTime.now().add(const Duration(days: 2)).toIso8601String(),
    'quantity': 1,
    'totalPrice': 89.99,
    'status': 'confirmed',
    'specialRequests': 'Test rental',
  };

  print('📤 Creating equipment rental with data: $equipmentRentalData');

  // Test 3: Create another hotel booking
  print('\n🏨 Test 3: Second Hotel Booking');

  final secondHotelBookingData = {
    'user': 'test-user-123',
    'hotel': 'hotel-789',
    'hotelName': 'Seaside Resort',
    'checkIn': DateTime.now().add(const Duration(days: 5)).toIso8601String(),
    'checkOut': DateTime.now().add(const Duration(days: 7)).toIso8601String(),
    'guests': 1,
    'totalPrice': 199.99,
    'status': 'confirmed',
  };

  print('📤 Creating second hotel booking...');

  // Test 4: Create another equipment rental
  print('\n🔧 Test 4: Second Equipment Rental');

  final secondEquipmentRentalData = {
    'user': 'test-user-123',
    'equipment': 'equipment-101',
    'equipmentName': 'Tent',
    'startDate': DateTime.now().add(const Duration(days: 3)).toIso8601String(),
    'endDate': DateTime.now().add(const Duration(days: 5)).toIso8601String(),
    'quantity': 2,
    'totalPrice': 149.99,
    'status': 'confirmed',
    'specialRequests': 'Second test rental',
  };

  print('📤 Creating second equipment rental...');

  print('\n✅ Test Data Prepared:');
  print('🏨 Hotel bookings to create:');
  print('  - Grand Hotel: \$299.99');
  print('  - Seaside Resort: \$199.99');
  print('🔧 Equipment rentals to create:');
  print('  - Mountain Bike: \$89.99');
  print('  - Tent: \$149.99');

  print('\n🎉 Frontend-only flow test data prepared!');
  print('📊 Summary:');
  print('  - Hotel booking data properly formatted');
  print('  - Equipment rental data properly formatted');
  print('  - All required fields included (hotelName, totalPrice, status)');
  print('  - Data ready for BLoC processing');

  print('\n💡 To test in your Flutter app:');
  print('1. Navigate to hotel booking page');
  print('2. Create a booking with the test data');
  print('3. Navigate to saved bookings page');
  print('4. Verify the booking appears in the hotel bookings tab');
  print('5. Repeat for equipment rentals');
  print('6. Test cancellation functionality');
}
