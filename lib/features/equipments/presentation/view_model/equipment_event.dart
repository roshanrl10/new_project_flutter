abstract class EquipmentEvent {}

class FetchEquipments extends EquipmentEvent {}

class FetchUserEquipmentRentals extends EquipmentEvent {
  final String userId;
  FetchUserEquipmentRentals(this.userId);
}

class FilterEquipments extends EquipmentEvent {
  final String query;
  FilterEquipments(this.query);
}

class FilterEquipmentsByCategory extends EquipmentEvent {
  final String category;
  FilterEquipmentsByCategory(this.category);
}

class FilterEquipmentsByPrice extends EquipmentEvent {
  final String priceRange;
  FilterEquipmentsByPrice(this.priceRange);
}

class RentEquipment extends EquipmentEvent {
  final Map<String, dynamic> rentalData;
  RentEquipment(this.rentalData);
}

class CancelEquipmentRental extends EquipmentEvent {
  final String rentalId;
  CancelEquipmentRental(this.rentalId);
}
