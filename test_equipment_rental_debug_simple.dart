import 'package:new_project_flutter/features/equipments/domain/entity/equipment_rental_entity.dart';

void main() {
  print('🔧 Testing Equipment Rental Debug (Simple)...');

  // Test 1: Create equipment rental data
  print('\n🔧 Test 1: Creating Equipment Rental Data');

  final rentalData = {
    'user': '688339f4171a690ae2d5d852',
    'equipment': 'equipment-123',
    'equipmentName': 'Mountain Bike',
    'startDate': DateTime.now().add(const Duration(days: 1)).toIso8601String(),
    'endDate': DateTime.now().add(const Duration(days: 3)).toIso8601String(),
    'quantity': 2,
    'totalPrice': 179.98,
    'status': 'confirmed',
    'specialRequests': 'Test rental',
  };

  print('📤 Rental data:');
  print('  - Equipment Name: ${rentalData['equipmentName']}');
  print('  - Status: ${rentalData['status']}');
  print('  - Total Price: ${rentalData['totalPrice']}');
  print('  - Quantity: ${rentalData['quantity']}');

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

    print('✅ EquipmentRental created successfully!');
    print('  - ID: ${rental.id}');
    print('  - Equipment Name: ${rental.equipmentName}');
    print('  - Status: ${rental.status}');
    print('  - Total Price: ${rental.totalPrice}');
    print('  - Quantity: ${rental.quantity}');

    // Test 3: Verify the data is correct for display
    print('\n🔧 Test 3: Verifying Display Data');
    print('  - Equipment Name (for display): ${rental.equipmentName}');
    print('  - Status (for filter): ${rental.status}');
    print('  - Total Price (for display): ${rental.totalPrice}');
    print('  - Quantity (for display): ${rental.quantity}');

    if (rental.equipmentName.isNotEmpty && rental.status == 'confirmed') {
      print('✅ Rental should be visible in saved bookings page');
    } else {
      print('❌ Rental might not be visible:');
      if (rental.equipmentName.isEmpty) print('  - Equipment name is empty');
      if (rental.status != 'confirmed') print('  - Status is not confirmed');
    }
  } catch (e) {
    print('❌ Error creating EquipmentRental: $e');
  }

  print('\n🎉 Equipment rental debug test completed!');
  print('💡 Next Steps:');
  print('1. Test the equipment rental in your Flutter app');
  print('2. Check console for debug messages');
  print('3. Look for the debug prints we added');
}
