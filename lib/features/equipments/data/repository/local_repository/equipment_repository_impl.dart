import 'package:new_project_flutter/features/equipments/data/data_source/local_datasource/equipment_remote_datasource.dart';
// import 'package:new_project_flutter/features/equipments/data/model/equipment_model.dart';
import 'package:new_project_flutter/features/equipments/domain/entity/equipment_entity.dart';
import 'package:new_project_flutter/features/equipments/domain/entity/equipment_rental_entity.dart';
import 'package:new_project_flutter/features/equipments/domain/repository/equipment_repository.dart';

class EquipmentRepositoryImpl implements EquipmentRepository {
  final EquipmentRemoteDataSource dataSource;

  EquipmentRepositoryImpl(this.dataSource);

  @override
  Future<List<Equipment>> fetchEquipments() async {
    final models = await dataSource.fetchEquipments();
    return models.map((model) => model.toEntity()).toList();
  }

  @override
  Future<Equipment> createEquipment(Map<String, dynamic> equipmentData) async {
    // Local implementation doesn't support creating equipment
    throw UnimplementedError(
      'Create equipment not supported in local implementation',
    );
  }

  @override
  Future<List<EquipmentRental>> fetchUserEquipmentRentals(String userId) async {
    // Local implementation doesn't support equipment rentals
    throw UnimplementedError(
      'Equipment rentals not supported in local implementation',
    );
  }

  @override
  Future<EquipmentRental> createEquipmentRental(
    Map<String, dynamic> rentalData,
  ) async {
    // Local implementation doesn't support creating equipment rentals
    throw UnimplementedError(
      'Create equipment rental not supported in local implementation',
    );
  }

  @override
  Future<void> deleteEquipmentRental(String rentalId) async {
    // Local implementation doesn't support deleting equipment rentals
    throw UnimplementedError(
      'Delete equipment rental not supported in local implementation',
    );
  }
}
