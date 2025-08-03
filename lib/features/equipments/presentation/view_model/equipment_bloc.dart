import 'package:new_project_flutter/features/equipments/domain/entity/equipment_entity.dart';
import 'package:new_project_flutter/features/equipments/domain/entity/equipment_rental_entity.dart';
import 'package:new_project_flutter/features/equipments/domain/repository/equipment_repository.dart';
import 'package:new_project_flutter/features/equipments/presentation/view_model/equipment_event.dart';
import 'package:new_project_flutter/features/equipments/presentation/view_model/equipment_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EquipmentBloc extends Bloc<EquipmentEvent, EquipmentState> {
  final EquipmentRepository repository;
  List<Equipment> _allEquipments = [];
  // Make local rentals static so they persist across bloc recreations
  static List<EquipmentRental> _localRentals = []; // Store rentals locally

  EquipmentBloc(this.repository) : super(EquipmentInitial()) {
    on<FetchEquipments>((event, emit) async {
      emit(EquipmentLoading());
      try {
        _allEquipments = await repository.fetchEquipments();
        emit(EquipmentLoaded(_allEquipments));
      } catch (e) {
        emit(EquipmentError(e.toString()));
      }
    });

    on<FetchUserEquipmentRentals>((event, emit) async {
      emit(EquipmentRentalLoading());
      try {
        print('🔧 Fetching equipment rentals from local state...');
        print('🔧 Found ${_localRentals.length} local rentals');

        // Debug: Print all local rentals
        for (int i = 0; i < _localRentals.length; i++) {
          final rental = _localRentals[i];
          print(
            '🔧 Local rental $i: ${rental.equipmentName} (${rental.status}) - \$${rental.totalPrice}',
          );
        }

        emit(EquipmentRentalLoaded(_localRentals));
      } catch (e) {
        emit(EquipmentRentalError(e.toString()));
      }
    });

    on<RentEquipment>((event, emit) async {
      print('🔧 RentEquipment event triggered');
      emit(EquipmentRentalActionLoading());
      try {
        print('🔧 Creating equipment rental locally...');

        // Create rental locally without backend
        print('🔧 Creating EquipmentRental with data:');
        print('  - Equipment ID: ${event.rentalData['equipment']}');
        print('  - Equipment Name: ${event.rentalData['equipmentName']}');
        print('  - User ID: ${event.rentalData['user']}');
        print('  - Start Date: ${event.rentalData['startDate']}');
        print('  - End Date: ${event.rentalData['endDate']}');
        print('  - Total Price: ${event.rentalData['totalPrice']}');
        print('  - Status: ${event.rentalData['status']}');
        print('  - Quantity: ${event.rentalData['quantity']}');

        final rental = EquipmentRental(
          id:
              DateTime.now().millisecondsSinceEpoch
                  .toString(), // Generate local ID
          equipmentId: event.rentalData['equipment'] ?? '',
          userId: event.rentalData['user'] ?? '',
          startDate: DateTime.parse(event.rentalData['startDate']),
          endDate: DateTime.parse(event.rentalData['endDate']),
          totalPrice: (event.rentalData['totalPrice'] as num).toDouble(),
          status: event.rentalData['status'] ?? 'confirmed',
          equipmentName:
              event.rentalData['equipmentName'] ?? 'Unknown Equipment',
          userName: 'Current User',
          quantity: event.rentalData['quantity'] ?? 1,
          specialRequests: event.rentalData['specialRequests'] ?? '',
        );

        print('🔧 EquipmentRental created successfully:');
        print('  - ID: ${rental.id}');
        print('  - Equipment Name: ${rental.equipmentName}');
        print('  - Status: ${rental.status}');
        print('  - Total Price: ${rental.totalPrice}');
        print('  - Quantity: ${rental.quantity}');

        // Add to local rentals
        _localRentals.add(rental);
        print('🔧 Equipment rental added to local state');
        print('🔧 Total local rentals: ${_localRentals.length}');

        // Emit loaded state with local rentals
        print('🔄 Emitting EquipmentRentalLoaded state with local rentals');
        emit(EquipmentRentalLoaded(_localRentals));

        // Then emit success state
        print('🔧 Emitting success state');
        emit(EquipmentRentalSuccess('Equipment rented successfully!'));
      } catch (e) {
        print('❌ Error in RentEquipment: $e');
        emit(EquipmentRentalError(e.toString()));
      }
    });

    on<CancelEquipmentRental>((event, emit) async {
      emit(EquipmentRentalActionLoading());
      try {
        print('🔧 Cancelling equipment rental locally...');

        // Remove rental from local state
        _localRentals.removeWhere((rental) => rental.id == event.rentalId);
        print('🔧 Rental removed from local state');
        print('🔧 Remaining local rentals: ${_localRentals.length}');

        // Emit updated rentals
        emit(EquipmentRentalLoaded(_localRentals));
        emit(
          EquipmentRentalSuccess('Equipment rental cancelled successfully!'),
        );
      } catch (e) {
        emit(EquipmentRentalError(e.toString()));
      }
    });

    on<FilterEquipments>((event, emit) {
      final filtered =
          _allEquipments
              .where(
                (e) => e.name.toLowerCase().contains(event.query.toLowerCase()),
              )
              .toList();
      emit(EquipmentLoaded(filtered));
    });

    on<FilterEquipmentsByCategory>((event, emit) {
      // TODO: Implement category filter
    });

    on<FilterEquipmentsByPrice>((event, emit) {
      // TODO: Implement price filter
    });
  }

  // Debug method to clear local rentals
  static void clearLocalRentals() {
    _localRentals.clear();
    print('🔧 Local rentals cleared');
  }

  // Debug method to get local rentals count
  static int getLocalRentalsCount() {
    return _localRentals.length;
  }
}
