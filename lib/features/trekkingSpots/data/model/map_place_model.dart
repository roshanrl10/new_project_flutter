import 'package:hive/hive.dart';
import 'package:new_project_flutter/features/trekkingSpots/domain/entity/map_place_entity.dart';

part 'map_place_model.g.dart';

@HiveType(typeId: 4)
class MapPlaceModel extends MapPlace {
  @override
  @HiveField(0)
  final String id;

  @override
  @HiveField(1)
  final String name;

  @override
  @HiveField(2)
  final double latitude;

  @override
  @HiveField(3)
  final double longitude;

  @override
  @HiveField(4)
  final String difficulty;

  @override
  @HiveField(5)
  final int elevation;

  MapPlaceModel({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.difficulty,
    required this.elevation,
  }) : super(
         id: id,
         name: name,
         latitude: latitude,
         longitude: longitude,
         difficulty: difficulty,
         elevation: elevation,
       );

  factory MapPlaceModel.fromJson(Map<String, dynamic> json) {
    return MapPlaceModel(
      id: json['_id'] ?? json['id'] ?? '',
      name: json['name'] ?? '',
      latitude: (json['latitude'] ?? 0.0).toDouble(),
      longitude: (json['longitude'] ?? 0.0).toDouble(),
      difficulty: json['difficulty'] ?? 'Moderate',
      elevation: json['elevation'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'latitude': latitude,
      'longitude': longitude,
      'difficulty': difficulty,
      'elevation': elevation,
    };
  }
}
