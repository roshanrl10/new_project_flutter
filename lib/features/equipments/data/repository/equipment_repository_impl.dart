import '../../domain/repository/equipment_repository.dart';
import '../../domain/entity/equipment_entity.dart';
import '../../domain/entity/equipment_rental_entity.dart';
import '../data_source/remote_datasource/equipment_remote_datasource.dart';
import '../data_source/remote_datasource/equipment_rental_remote_datasource.dart';
// import '../model/equipment_model.dart';
// import '../model/equipment_rental_model.dart';

class EquipmentRepositoryImpl implements EquipmentRepository {
  final EquipmentRemoteDataSource equipmentRemoteDataSource;
  final EquipmentRentalRemoteDataSource rentalRemoteDataSource;

  EquipmentRepositoryImpl({
    required this.equipmentRemoteDataSource,
    required this.rentalRemoteDataSource,
  });

  @override
  Future<List<Equipment>> fetchEquipments() async {
    final models = await equipmentRemoteDataSource.fetchEquipments();
    return models.map((model) => model.toEntity()).toList();
  }

  @override
  Future<Equipment> createEquipment(Map<String, dynamic> equipmentData) async {
    final model = await equipmentRemoteDataSource.createEquipment(
      equipmentData,
    );
    return model.toEntity();
  }

  @override
  Future<List<EquipmentRental>> fetchUserEquipmentRentals(String userId) async {
    final models = await rentalRemoteDataSource.fetchUserEquipmentRentals(
      userId,
    );
    return models.map((model) => model.toEntity()).toList();
  }

  @override
  Future<EquipmentRental> createEquipmentRental(
    Map<String, dynamic> rentalData,
  ) async {
    final model = await rentalRemoteDataSource.createEquipmentRental(
      rentalData,
    );
    return model.toEntity();
  }

  @override
  Future<void> deleteEquipmentRental(String rentalId) async {
    await rentalRemoteDataSource.deleteEquipmentRental(rentalId);
  }
}
