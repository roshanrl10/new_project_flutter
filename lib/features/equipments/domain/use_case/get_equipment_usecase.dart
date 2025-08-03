import 'package:new_project_flutter/features/equipments/domain/entity/equipment_entity.dart';
import 'package:new_project_flutter/features/equipments/domain/repository/equipment_repository.dart';

class GetEquipmentsUseCase {
  final EquipmentRepository repository;

  GetEquipmentsUseCase(this.repository);

  /// Fetch all equipments
  Future<List<Equipment>> call() async {
    return repository.fetchEquipments();
  }

  /// Fetch filtered equipments by query
  Future<List<Equipment>> filter(String query) async {
    final allEquipments = await repository.fetchEquipments();
    return allEquipments.where((equipment) {
      return equipment.name.toLowerCase().contains(query.toLowerCase()) ||
          equipment.description.toLowerCase().contains(query.toLowerCase());
    }).toList();
  }
}
