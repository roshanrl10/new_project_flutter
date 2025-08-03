import 'package:new_project_flutter/features/hotelBooking/domain/entity/hotel_entity.dart';

class HotelModel extends Hotel {
  HotelModel({
    required super.id,
    required super.name,
    required super.location,
    required super.description,
    required super.services,
    required super.price,
    required super.imageUrl,
    required super.rating,
    required super.available,
  });

  factory HotelModel.fromJson(Map<String, dynamic> json) {
    // Safely convert amenities to List<String>
    List<String> amenities = [];
    if (json['amenities'] != null) {
      try {
        if (json['amenities'] is List) {
          amenities =
              (json['amenities'] as List)
                  .map((item) => item?.toString() ?? '')
                  .where((item) => item.isNotEmpty)
                  .toList();
        }
      } catch (e) {
        print('⚠️ Error parsing amenities: $e');
        amenities = [];
      }
    }

    return HotelModel(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      location: json['location']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      services: amenities,
      price: _safeParseDouble(json['price']),
      imageUrl: json['image']?.toString() ?? '',
      rating: _safeParseDouble(json['rating']),
      available: json['available'] == true,
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

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'location': location,
      'description': description,
      'amenities': services,
      'price': price,
      'image': imageUrl,
      'rating': rating,
      'available': available,
    };
  }

  Hotel toEntity() {
    return Hotel(
      id: id,
      name: name,
      location: location,
      description: description,
      services: services,
      price: price,
      imageUrl: imageUrl,
      rating: rating,
      available: available,
    );
  }

  factory HotelModel.fromEntity(Hotel hotel) {
    return HotelModel(
      id: hotel.id,
      name: hotel.name,
      location: hotel.location,
      description: hotel.description,
      services: hotel.services,
      price: hotel.price,
      imageUrl: hotel.imageUrl,
      rating: hotel.rating,
      available: hotel.available,
    );
  }
}
