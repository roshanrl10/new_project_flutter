import 'package:hive/hive.dart';
import 'package:new_project_flutter/features/weather/domain/entity/trekking_place.dart';

part 'trekking_place_model.g.dart';

@HiveType(typeId: 3)
class TrekkingPlaceModel extends TrekkingPlace {
  @HiveField(0)
  final String placeName;

  @HiveField(1)
  final double lat;

  @HiveField(2)
  final double lon;

  TrekkingPlaceModel({
    required this.placeName,
    required this.lat,
    required this.lon,
  }) : super(name: placeName, latitude: lat, longitude: lon);
}
