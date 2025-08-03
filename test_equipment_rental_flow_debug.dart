import 'package:new_project_flutter/features/equipments/domain/entity/equipment_rental_entity.dart';

void main() {
  print('🔧 Testing Equipment Rental Flow Debug...');

  // Simulate the exact flow that happens in the Flutter app

  print('\n📋 STEP 1: Create rental data (same as in equipments_page.dart)');
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

  print('📤 Rental data created:');
  print('  - Equipment Name: ${rentalData['equipmentName']}');
  print('  - Status: ${rentalData['status']}');
  print('  - Total Price: ${rentalData['totalPrice']}');
  print('  - Quantity: ${rentalData['quantity']}');

  print(
    '\n📋 STEP 2: Create EquipmentRental entity (same as in EquipmentBloc)',
  );
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
    print('  - User ID: ${rental.userId}');

    print('\n📋 STEP 3: Simulate adding to local rentals list');
    List<EquipmentRental> localRentals = [];
    localRentals.add(rental);
    print('✅ Added rental to local rentals list');
    print('🔧 Total local rentals: ${localRentals.length}');

    print('\n📋 STEP 4: Simulate EquipmentRentalLoaded state');
    print('🔧 EquipmentRentalLoaded state would contain:');
    print('  - ${localRentals.length} rentals');
    for (int i = 0; i < localRentals.length; i++) {
      final r = localRentals[i];
      print('  - Rental $i: ${r.equipmentName} (${r.status})');
    }

    print('\n📋 STEP 5: Simulate filtering confirmed rentals');
    final confirmedRentals =
        localRentals.where((r) => r.status == 'confirmed').toList();
    print('🔧 Confirmed rentals: ${confirmedRentals.length}');

    if (confirmedRentals.isNotEmpty) {
      print('✅ Rental should be displayed in saved bookings page');
      print('  - Equipment Name: ${confirmedRentals[0].equipmentName}');
      print('  - Status: ${confirmedRentals[0].status}');
      print('  - Total Price: ${confirmedRentals[0].totalPrice}');
      print('  - Quantity: ${confirmedRentals[0].quantity}');
    } else {
      print('❌ No confirmed rentals found - this is the problem!');
    }

    print('\n📋 STEP 6: Verify data for UI display');
    if (confirmedRentals.isNotEmpty) {
      final rentalForDisplay = confirmedRentals[0];
      print('🔧 Data for UI card:');
      print('  - Equipment Name: ${rentalForDisplay.equipmentName}');
      print('  - Status: ${rentalForDisplay.status}');
      print('  - Total Price: ${rentalForDisplay.totalPrice}');
      print('  - Quantity: ${rentalForDisplay.quantity}');
      print('  - Start Date: ${rentalForDisplay.startDate}');
      print('  - End Date: ${rentalForDisplay.endDate}');

      // Check if any field is empty or null
      if (rentalForDisplay.equipmentName.isEmpty) {
        print('❌ Equipment name is empty!');
      }
      if (rentalForDisplay.status.isEmpty) {
        print('❌ Status is empty!');
      }
      if (rentalForDisplay.totalPrice <= 0) {
        print('❌ Total price is invalid!');
      }
      if (rentalForDisplay.quantity <= 0) {
        print('❌ Quantity is invalid!');
      }
    }
  } catch (e) {
    print('❌ Error in equipment rental flow: $e');
  }

  print('\n🎉 Equipment rental flow debug completed!');
  print('💡 If the test passes but rentals still don\'t show in Flutter:');
  print('1. Check if EquipmentBloc is being recreated');
  print('2. Check if the saved bookings page is receiving the correct state');
  print('3. Check if there are any UI rendering issues');
  print('4. Check the console for any error messages');
}
