import 'package:new_project_flutter/features/equipments/domain/entity/equipment_entity.dart';

class EquipmentModel extends Equipment {
  EquipmentModel({
    required super.id,
    required super.name,
    required super.category,
    required super.description,
    required super.price,
    required super.imageUrl,
    required super.quantity,
    required super.brand,
    required super.available,
    required super.condition,
    required super.location,
  });

  factory EquipmentModel.fromJson(Map<String, dynamic> json) {
    return EquipmentModel(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      category: json['category']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      price: _safeParseDouble(json['price']),
      imageUrl: json['image']?.toString() ?? '',
      quantity: json['quantity'] ?? 1,
      brand: json['brand']?.toString() ?? '',
      available: json['available'] == true,
      condition: json['condition']?.toString() ?? 'good',
      location: json['location']?.toString() ?? '',
    );
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

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'category': category,
    'description': description,
    'price': price,
    'image': imageUrl,
    'quantity': quantity,
    'brand': brand,
    'available': available,
    'condition': condition,
    'location': location,
  };

  Equipment toEntity() {
    return Equipment(
      id: id,
      name: name,
      category: category,
      description: description,
      price: price,
      imageUrl: imageUrl,
      quantity: quantity,
      brand: brand,
      available: available,
      condition: condition,
      location: location,
    );
  }
}
