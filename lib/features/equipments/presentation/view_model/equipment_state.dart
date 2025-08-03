import 'package:new_project_flutter/features/equipments/domain/entity/equipment_entity.dart';
import 'package:new_project_flutter/features/equipments/domain/entity/equipment_rental_entity.dart';

abstract class EquipmentState {}

class EquipmentInitial extends EquipmentState {}

class EquipmentLoading extends EquipmentState {}

class EquipmentLoaded extends EquipmentState {
  final List<Equipment> equipments;

  EquipmentLoaded(this.equipments);
}

class EquipmentError extends EquipmentState {
  final String message;

  EquipmentError(this.message);
}

// User Equipment Rental States
class EquipmentRentalLoading extends EquipmentState {}

class EquipmentRentalLoaded extends EquipmentState {
  final List<EquipmentRental> equipmentRentals;

  EquipmentRentalLoaded(this.equipmentRentals);
}

class EquipmentRentalError extends EquipmentState {
  final String message;

  EquipmentRentalError(this.message);
}

// Rental Action States
class EquipmentRentalSuccess extends EquipmentState {
  final String message;
  EquipmentRentalSuccess(this.message);
}

class EquipmentRentalActionLoading extends EquipmentState {}

class EquipmentRentalCancelled extends EquipmentState {
  final String message;
  EquipmentRentalCancelled(this.message);
}
