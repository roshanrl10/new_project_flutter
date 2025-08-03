import 'package:new_project_flutter/features/equipments/domain/entity/equipment_entity.dart';
import 'package:new_project_flutter/features/equipments/domain/entity/equipment_rental_entity.dart';

abstract class EquipmentRepository {
  Future<List<Equipment>> fetchEquipments();
  Future<Equipment> createEquipment(Map<String, dynamic> equipmentData);
  Future<List<EquipmentRental>> fetchUserEquipmentRentals(String userId);
  Future<EquipmentRental> createEquipmentRental(
    Map<String, dynamic> rentalData,
  );
  Future<void> deleteEquipmentRental(String rentalId);
}
