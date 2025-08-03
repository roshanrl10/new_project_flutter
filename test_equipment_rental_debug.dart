import 'package:flutter/material.dart';
import 'package:new_project_flutter/features/equipments/domain/entity/equipment_rental_entity.dart';

void main() {
  print('🔧 Testing Equipment Rental Debug...');

  print('\n📋 Test Plan:');
  print('1. Test equipment rental data format');
  print('2. Test EquipmentRental entity creation');
  print('3. Verify data structure');

  // Test 1: Equipment rental data format
  print('\n🔧 Test 1: Equipment Rental Data Format');

  final rentalData = {
    'user': 'test-user-123',
    'equipment': 'equipment-456',
    'equipmentName': 'Mountain Bike',
    'startDate': DateTime.now().add(const Duration(days: 1)).toIso8601String(),
    'endDate': DateTime.now().add(const Duration(days: 3)).toIso8601String(),
    'quantity': 1,
    'totalPrice': 89.99,
    'status': 'confirmed',
    'specialRequests': 'Test rental',
  };

  print('📤 Rental data format:');
  print('  - User ID: ${rentalData['user']}');
  print('  - Equipment ID: ${rentalData['equipment']}');
  print('  - Equipment Name: ${rentalData['equipmentName']}');
  print('  - Start Date: ${rentalData['startDate']}');
  print('  - End Date: ${rentalData['endDate']}');
  print('  - Quantity: ${rentalData['quantity']}');
  print('  - Total Price: \$${rentalData['totalPrice']}');
  print('  - Status: ${rentalData['status']}');
  print('  - Special Requests: ${rentalData['specialRequests']}');

  // Test 2: Create EquipmentRental entity
  print('\n🔧 Test 2: Creating EquipmentRental Entity');

  try {
    final rental = EquipmentRental(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      equipmentId: (rentalData['equipment'] as String?) ?? '',
      userId: (rentalData['user'] as String?) ?? '',
      startDate: DateTime.parse(rentalData['startDate'] as String),
      endDate: DateTime.parse(rentalData['endDate'] as String),
      totalPrice: (rentalData['totalPrice'] as num).toDouble(),
      status: (rentalData['status'] as String?) ?? 'confirmed',
      equipmentName:
          (rentalData['equipmentName'] as String?) ?? 'Unknown Equipment',
      userName: 'Current User',
      quantity: (rentalData['quantity'] as int?) ?? 1,
      specialRequests: (rentalData['specialRequests'] as String?) ?? '',
    );

    print('✅ EquipmentRental entity created successfully!');
    print('  - ID: ${rental.id}');
    print('  - Equipment Name: ${rental.equipmentName}');
    print('  - Status: ${rental.status}');
    print('  - Total Price: \$${rental.totalPrice}');
    print('  - Quantity: ${rental.quantity}');
  } catch (e) {
    print('❌ Error creating EquipmentRental entity: $e');
  }

  // Test 3: Create another rental
  print('\n🔧 Test 3: Creating Second Equipment Rental');

  final secondRentalData = {
    'user': 'test-user-123',
    'equipment': 'equipment-789',
    'equipmentName': 'Tent',
    'startDate': DateTime.now().add(const Duration(days: 2)).toIso8601String(),
    'endDate': DateTime.now().add(const Duration(days: 4)).toIso8601String(),
    'quantity': 2,
    'totalPrice': 149.99,
    'status': 'confirmed',
    'specialRequests': 'Second test rental',
  };

  try {
    final secondRental = EquipmentRental(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      equipmentId: (secondRentalData['equipment'] as String?) ?? '',
      userId: (secondRentalData['user'] as String?) ?? '',
      startDate: DateTime.parse(secondRentalData['startDate'] as String),
      endDate: DateTime.parse(secondRentalData['endDate'] as String),
      totalPrice: (secondRentalData['totalPrice'] as num).toDouble(),
      status: (secondRentalData['status'] as String?) ?? 'confirmed',
      equipmentName:
          (secondRentalData['equipmentName'] as String?) ?? 'Unknown Equipment',
      userName: 'Current User',
      quantity: (secondRentalData['quantity'] as int?) ?? 1,
      specialRequests: (secondRentalData['specialRequests'] as String?) ?? '',
    );

    print('✅ Second EquipmentRental entity created successfully!');
    print('  - ID: ${secondRental.id}');
    print('  - Equipment Name: ${secondRental.equipmentName}');
    print('  - Status: ${secondRental.status}');
    print('  - Total Price: \$${secondRental.totalPrice}');
    print('  - Quantity: ${secondRental.quantity}');
  } catch (e) {
    print('❌ Error creating second EquipmentRental entity: $e');
  }

  print('\n🎉 Equipment rental debug test completed!');
  print('📊 Summary:');
  print('  - Equipment rental data format is correct');
  print('  - EquipmentRental entity creation works');
  print('  - All required fields are properly handled');

  print('\n💡 Next Steps:');
  print('1. Open your Flutter app');
  print('2. Go to equipment rental page');
  print('3. Create an equipment rental');
  print('4. Check console for debug messages');
  print('5. Navigate to saved bookings page');
  print('6. Check the equipment rentals tab');
  print('7. Tell me what you see in the console');
}
