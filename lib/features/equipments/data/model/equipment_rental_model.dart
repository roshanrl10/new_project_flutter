import '../../domain/entity/equipment_rental_entity.dart';

class EquipmentRentalModel extends EquipmentRental {
  EquipmentRentalModel({
    required super.id,
    required super.equipmentId,
    required super.userId,
    required super.startDate,
    required super.endDate,
    required super.totalPrice,
    required super.status,
    required super.equipmentName,
    required super.userName,
    required super.quantity,
    required super.specialRequests,
  });

  factory EquipmentRentalModel.fromJson(Map<String, dynamic> json) {
    print('🔧 Parsing equipment rental JSON: $json');

    // Handle populated equipment object
    String equipmentName = '';
    String equipmentId = '';
    if (json['equipment'] is Map<String, dynamic>) {
      final equipment = json['equipment'] as Map<String, dynamic>;
      equipmentName = equipment['name']?.toString() ?? '';
      equipmentId = equipment['_id']?.toString() ?? '';
    } else {
      equipmentId = json['equipment']?.toString() ?? '';
      equipmentName = json['equipmentName']?.toString() ?? '';
    }

    // Handle populated user object
    String userName = '';
    String userId = '';
    if (json['user'] is Map<String, dynamic>) {
      final user = json['user'] as Map<String, dynamic>;
      userName = user['username']?.toString() ?? '';
      userId = user['_id']?.toString() ?? '';
    } else {
      userId = json['user']?.toString() ?? '';
      userName = json['userName']?.toString() ?? '';
    }

    final rentalModel = EquipmentRentalModel(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      equipmentId: equipmentId,
      userId: userId,
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      totalPrice: _safeParseDouble(json['totalPrice']),
      status: json['status']?.toString() ?? 'pending',
      equipmentName: equipmentName,
      userName: userName,
      quantity: json['quantity'] ?? 1,
      specialRequests: json['specialRequests']?.toString() ?? '',
    );

    print(
      '🔧 Created equipment rental model: ${rentalModel.equipmentName} (${rentalModel.status})',
    );
    return rentalModel;
  }

  // Helper method to safely parse double values
  static double _safeParseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is int) return value.toDouble();
    if (value is double) return value;
    if (value is String) {
      try {
        return double.parse(value);
      } catch (e) {
        print('⚠️ Error parsing double from string: $value');
        return 0.0;
      }
    }
    return 0.0;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'equipment': equipmentId,
      'user': userId,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'totalPrice': totalPrice,
      'status': status,
      'equipmentName': equipmentName,
      'userName': userName,
      'quantity': quantity,
      'specialRequests': specialRequests,
    };
  }

  EquipmentRental toEntity() {
    return EquipmentRental(
      id: id,
      equipmentId: equipmentId,
      userId: userId,
      startDate: startDate,
      endDate: endDate,
      totalPrice: totalPrice,
      status: status,
      equipmentName: equipmentName,
      userName: userName,
      quantity: quantity,
      specialRequests: specialRequests,
    );
  }

  factory EquipmentRentalModel.fromEntity(EquipmentRental rental) {
    return EquipmentRentalModel(
      id: rental.id,
      equipmentId: rental.equipmentId,
      userId: rental.userId,
      startDate: rental.startDate,
      endDate: rental.endDate,
      totalPrice: rental.totalPrice,
      status: rental.status,
      equipmentName: rental.equipmentName,
      userName: rental.userName,
      quantity: rental.quantity,
      specialRequests: rental.specialRequests,
    );
  }
}
