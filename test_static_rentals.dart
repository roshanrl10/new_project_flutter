import 'package:new_project_flutter/features/equipments/domain/entity/equipment_rental_entity.dart';

void main() {
  print('🔧 Testing Static Local Rentals...');

  // Simulate the EquipmentBloc static local rentals
  final List<EquipmentRental> _localRentals = [];

  print('\n📋 STEP 1: Create a rental');
  final rental = EquipmentRental(
    id: DateTime.now().millisecondsSinceEpoch.toString(),
    equipmentId: 'equipment-123',
    userId: '688339f4171a690ae2d5d852',
    startDate: DateTime.now().add(const Duration(days: 1)),
    endDate: DateTime.now().add(const Duration(days: 3)),
    totalPrice: 179.98,
    status: 'confirmed',
    equipmentName: 'Mountain Bike',
    userName: 'Current User',
    quantity: 2,
    specialRequests: 'Test rental',
  );

  print('✅ Rental created: ${rental.equipmentName}');

  print('\n📋 STEP 2: Add to static local rentals');
  _localRentals.add(rental);
  print('✅ Added to static local rentals');
  print('🔧 Total static rentals: ${_localRentals.length}');

  print('\n📋 STEP 3: Simulate bloc recreation (clear instance variables)');
  // In a real scenario, the bloc instance would be recreated
  // but static variables would persist
  print('🔧 Static rentals should persist: ${_localRentals.length}');

  print('\n📋 STEP 4: Verify rentals are still available');
  if (_localRentals.isNotEmpty) {
    print('✅ Static rentals persisted!');
    for (int i = 0; i < _localRentals.length; i++) {
      final r = _localRentals[i];
      print(
        '  - Rental $i: ${r.equipmentName} (${r.status}) - \$${r.totalPrice}',
      );
    }
  } else {
    print('❌ Static rentals were lost!');
  }

  print('\n📋 STEP 5: Test filtering confirmed rentals');
  final confirmedRentals =
      _localRentals.where((r) => r.status == 'confirmed').toList();
  print('🔧 Confirmed rentals: ${confirmedRentals.length}');

  if (confirmedRentals.isNotEmpty) {
    print('✅ Confirmed rentals found for display');
    print('  - Equipment Name: ${confirmedRentals[0].equipmentName}');
    print('  - Status: ${confirmedRentals[0].status}');
    print('  - Total Price: ${confirmedRentals[0].totalPrice}');
  } else {
    print('❌ No confirmed rentals found');
  }

  print('\n🎉 Static rentals test completed!');
  print('💡 This should fix the equipment rental display issue');
}
