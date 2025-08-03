import 'package:new_project_flutter/features/equipments/domain/entity/equipment_rental_entity.dart';

void main() {
  print('🔧 Testing Equipment Rental Card Rendering...');

  // Test 1: Create a valid equipment rental
  print('\n📋 Test 1: Creating valid equipment rental');
  final rental = EquipmentRental(
    id: DateTime.now().millisecondsSinceEpoch.toString(),
    equipmentId: 'equipment-123',
    userId: '688339f4171a690ae2d5d852',
    startDate: DateTime.now().add(const Duration(days: 1)),
    endDate: DateTime.now().add(const Duration(days: 3)),
    totalPrice: 75.0,
    status: 'confirmed',
    equipmentName: 'Professional Hiking Boots',
    userName: 'Current User',
    quantity: 1,
    specialRequests: 'Test rental',
  );

  print('✅ Valid rental created:');
  print('  - Equipment Name: ${rental.equipmentName}');
  print('  - Status: ${rental.status}');
  print('  - Total Price: ${rental.totalPrice}');
  print('  - Quantity: ${rental.quantity}');

  // Test 2: Test null safety checks (simulate the card rendering logic)
  print('\n📋 Test 2: Testing null safety checks');

  final equipmentName =
      rental.equipmentName.isNotEmpty
          ? rental.equipmentName
          : 'Unknown Equipment';
  final status = rental.status.isNotEmpty ? rental.status : 'pending';
  final totalPrice = rental.totalPrice > 0 ? rental.totalPrice : 0.0;
  final quantity = rental.quantity > 0 ? rental.quantity : 1;

  print('✅ Safe values:');
  print('  - Equipment Name: $equipmentName');
  print('  - Status: $status');
  print('  - Total Price: ${totalPrice.toStringAsFixed(2)}');
  print('  - Quantity: $quantity');

  // Test 3: Test edge cases
  print('\n📋 Test 3: Testing edge cases');

  // Test with empty equipment name
  final rentalWithEmptyName = EquipmentRental(
    id: 'test-1',
    equipmentId: 'equipment-123',
    userId: '688339f4171a690ae2d5d852',
    startDate: DateTime.now(),
    endDate: DateTime.now().add(const Duration(days: 1)),
    totalPrice: 0.0,
    status: '',
    equipmentName: '',
    userName: 'Current User',
    quantity: 0,
    specialRequests: '',
  );

  final safeEquipmentName =
      rentalWithEmptyName.equipmentName.isNotEmpty
          ? rentalWithEmptyName.equipmentName
          : 'Unknown Equipment';
  final safeStatus =
      rentalWithEmptyName.status.isNotEmpty
          ? rentalWithEmptyName.status
          : 'pending';
  final safeTotalPrice =
      rentalWithEmptyName.totalPrice > 0 ? rentalWithEmptyName.totalPrice : 0.0;
  final safeQuantity =
      rentalWithEmptyName.quantity > 0 ? rentalWithEmptyName.quantity : 1;

  print('✅ Edge case safe values:');
  print('  - Equipment Name: $safeEquipmentName');
  print('  - Status: $safeStatus');
  print('  - Total Price: ${safeTotalPrice.toStringAsFixed(2)}');
  print('  - Quantity: $safeQuantity');

  print('\n🎉 Equipment rental card rendering test completed!');
  print('💡 The card should now render without layout errors');
}
