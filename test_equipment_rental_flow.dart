import 'package:dio/dio.dart';

void main() async {
  print('🔧 Testing Equipment Rental Flow...');

  final dio = Dio();

  try {
    // Test 1: Check current equipment rentals
    print('\n🧪 Test 1: Checking current equipment rentals...');
    final response1 = await dio.get(
      'http://127.0.0.1:3000/api/equipment/rentals',
      queryParameters: {'userId': '688339f4171a690ae2d5d852'},
    );

    print('✅ Current rentals: ${response1.data['rentals']?.length ?? 0}');
    final rentals = response1.data['rentals'] ?? [];
    for (var rental in rentals) {
      print(
        '  - ${rental['equipment']?['name'] ?? 'Unknown'} (${rental['status']})',
      );
    }

    // Test 2: Check available equipment
    print('\n🧪 Test 2: Checking available equipment...');
    final response2 = await dio.get('http://127.0.0.1:3000/api/equipment');

    print('✅ Available equipment: ${response2.data['equipment']?.length ?? 0}');
    final equipment = response2.data['equipment'] ?? [];
    if (equipment.isNotEmpty) {
      final firstEquipment = equipment[0];
      print(
        '✅ First equipment: ${firstEquipment['name']} (ID: ${firstEquipment['_id']})',
      );

      // Test 3: Create a new equipment rental
      print('\n🧪 Test 3: Creating a new equipment rental...');
      final rentalData = {
        'user': '688339f4171a690ae2d5d852',
        'equipment': firstEquipment['_id'],
        'equipmentName': firstEquipment['name'],
        'startDate': '2024-12-25',
        'endDate': '2024-12-27',
        'quantity': 1,
        'totalPrice': 60.0,
        'status': 'confirmed',
        'specialRequests': 'Test rental from Flutter',
      };

      final response3 = await dio.post(
        'http://127.0.0.1:3000/api/equipment/rentals',
        data: rentalData,
      );

      print('✅ Rental created successfully');
      print('✅ Rental ID: ${response3.data['_id']}');
      print('✅ Status: ${response3.data['status']}');
      print(
        '✅ Equipment: ${response3.data['equipment']?['name'] ?? 'Unknown'}',
      );

      // Test 4: Check rentals again
      print('\n🧪 Test 4: Checking rentals after creation...');
      final response4 = await dio.get(
        'http://127.0.0.1:3000/api/equipment/rentals',
        queryParameters: {'userId': '688339f4171a690ae2d5d852'},
      );

      print('✅ Updated rentals: ${response4.data['rentals']?.length ?? 0}');
      final updatedRentals = response4.data['rentals'] ?? [];
      for (var rental in updatedRentals) {
        print(
          '  - ${rental['equipment']?['name'] ?? 'Unknown'} (${rental['status']})',
        );
      }

      // Test 5: Verify the new rental is confirmed
      final newRental = updatedRentals.firstWhere(
        (rental) => rental['_id'] == response3.data['_id'],
        orElse: () => null,
      );

      if (newRental != null) {
        print('✅ New rental found in list');
        print('✅ Status: ${newRental['status']}');
        print('✅ Should appear in Flutter saved bookings page');
        print('✅ This rental should be visible in the equipment rentals tab');
      } else {
        print('❌ New rental not found in list');
      }

      // Test 6: Clean up - delete the test rental
      print('\n🧪 Test 6: Cleaning up test rental...');
      final response5 = await dio.delete(
        'http://127.0.0.1:3000/api/equipment/rentals/${response3.data['_id']}',
      );

      if (response5.statusCode == 200) {
        print('✅ Test rental deleted successfully');
      } else {
        print('❌ Failed to delete test rental');
      }
    } else {
      print('❌ No equipment available for testing');
    }

    print('\n✅ Equipment rental flow test completed');
    print('📱 Now test in Flutter app:');
    print('   1. Go to equipment rental page');
    print('   2. Rent an equipment');
    print('   3. Navigate to saved bookings page');
    print('   4. Check if the rental appears in equipment rentals tab');
    print('   5. The rental should be visible immediately after confirmation');
  } catch (e) {
    print('❌ Error during equipment rental test: $e');
  }
}
