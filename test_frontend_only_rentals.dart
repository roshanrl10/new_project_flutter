import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_project_flutter/features/equipments/presentation/view_model/equipment_bloc.dart';
import 'package:new_project_flutter/features/equipments/presentation/view_model/equipment_event.dart';
import 'package:new_project_flutter/features/equipments/presentation/view_model/equipment_state.dart';
import 'package:new_project_flutter/features/equipments/domain/repository/equipment_repository.dart';
import 'package:new_project_flutter/features/equipments/data/repository/equipment_repository_impl.dart';
import 'package:new_project_flutter/features/equipments/data/data_source/remote_datasource/equipment_remote_datasource.dart';
import 'package:new_project_flutter/features/equipments/data/data_source/remote_datasource/equipment_rental_remote_datasource.dart';

void main() async {
  print('🔧 Testing Frontend-Only Equipment Rentals...');

  // Create repository and bloc
  final equipmentRemoteDataSource = EquipmentRemoteDataSourceImpl();
  final equipmentRentalRemoteDataSource = EquipmentRentalRemoteDataSourceImpl();

  final repository = EquipmentRepositoryImpl(
    equipmentRemoteDataSource: equipmentRemoteDataSource,
    rentalRemoteDataSource: equipmentRentalRemoteDataSource,
  );

  final bloc = EquipmentBloc(repository);

  try {
    // Test 1: Check initial state
    print('\n🧪 Test 1: Checking initial state...');
    print('🔧 Initial state: ${bloc.state.runtimeType}');

    // Test 2: Create a rental locally
    print('\n🧪 Test 2: Creating a rental locally...');
    final rentalData = {
      'user': '688339f4171a690ae2d5d852',
      'equipment': 'test-equipment-id',
      'equipmentName': 'Test Equipment',
      'startDate': '2024-12-25',
      'endDate': '2024-12-27',
      'quantity': 1,
      'totalPrice': 60.0,
      'status': 'confirmed',
      'specialRequests': 'Test rental from frontend',
    };

    bloc.add(RentEquipment(rentalData));

    // Wait a bit for the bloc to process
    await Future.delayed(Duration(milliseconds: 100));

    // Test 3: Check if rental was added to local state
    print('\n🧪 Test 3: Checking if rental was added to local state...');
    bloc.add(FetchUserEquipmentRentals('688339f4171a690ae2d5d852'));

    // Wait a bit for the bloc to process
    await Future.delayed(Duration(milliseconds: 100));

    // Test 4: Verify the rental appears in saved bookings
    print('\n🧪 Test 4: Verifying rental appears in saved bookings...');
    if (bloc.state is EquipmentRentalLoaded) {
      final state = bloc.state as EquipmentRentalLoaded;
      print('✅ Found ${state.equipmentRentals.length} rentals in local state');

      for (var rental in state.equipmentRentals) {
        print('  - ${rental.equipmentName} (${rental.status})');
        print('    Start: ${rental.startDate}');
        print('    End: ${rental.endDate}');
        print('    Price: \$${rental.totalPrice}');
      }

      // Test 5: Cancel the rental
      print('\n🧪 Test 5: Cancelling the rental...');
      if (state.equipmentRentals.isNotEmpty) {
        final rentalToCancel = state.equipmentRentals.first;
        bloc.add(CancelEquipmentRental(rentalToCancel.id));

        // Wait a bit for the bloc to process
        await Future.delayed(Duration(milliseconds: 100));

        // Check if rental was removed
        bloc.add(FetchUserEquipmentRentals('688339f4171a690ae2d5d852'));
        await Future.delayed(Duration(milliseconds: 100));

        if (bloc.state is EquipmentRentalLoaded) {
          final updatedState = bloc.state as EquipmentRentalLoaded;
          print('✅ Remaining rentals: ${updatedState.equipmentRentals.length}');
        }
      }
    }

    print('\n✅ Frontend-only equipment rental test completed');
    print('📱 Now test in Flutter app:');
    print('   1. Go to equipment rental page');
    print('   2. Rent an equipment');
    print('   3. Navigate to saved bookings page');
    print('   4. Check if the rental appears in equipment rentals tab');
    print('   5. The rental should be visible immediately (no backend needed)');
  } catch (e) {
    print('❌ Error during frontend-only test: $e');
  }
}
